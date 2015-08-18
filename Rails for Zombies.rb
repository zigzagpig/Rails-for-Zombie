#LEVEL 1 数据库相关

#1 查找
Zombie.find(1)
#2 创建
Zombie.create
#3 查找 2
Zombie.last
#4 查询排序
Zombie.all.order(:name)
#5 更新
z = Zombie.find(3)
z.graveyard = "Benny Hills Memorial"
z.save
#6 删除
Zombie.find(3).destroy

#LEVEL 2 模型
#1 写类（名没有S）
class Zombie < ActiveRecord::Base

end
#2 验证
class Zombie < ActiveRecord::Base
  # insert validation here
  validates :name, presence: true
end
#3 验证唯一性
class Zombie < ActiveRecord::Base
  validates :name, uniqueness: true
end
#4 双重验证上一关
class Zombie < ActiveRecord::Base
  validates :name, uniqueness: true, presence: true
end
#5 模型の归属
class Weapon < ActiveRecord::Base
  belongs_to :zombie
end
#6 belongs_to 和 has_many的使用
Zombie.find_by(name: 'Ashley').weapons

#LEVEL 3 视图练习
#1 视图例子
<h1><%= zombie.name %></h1>

<p>
  <%= zombie.graveyard %>
</p>
#2 CRUD 的好处之show的链接
<p>
<%= link_to zombie.name, zombie %>
</p>
#3 块初步
<ul>
<% zombies.each do |zombie| %>
  <%= zombie.name %>
<% end %>
</ul>
#4 if 的使用
<ul>
  <% zombies.each do |zombie| %>
    <li>
      <%= zombie.name %>
      <% if zombie.tweets.count > 1 %>
        SMART ZOMBIE
      <% end %>
    </li>
  <% end %>
</ul>
#5 学习块
<ul>
  <% zombies.each do |zombie| %>
    <li>
      <%= link_to zombie.name, edit_zombie_path(zombie) %>
    </li>
  <% end %>
</ul>

#LEVEL 4 动作练习
#1 show动作的查找
def show
  @zombie = Zombie.find(params[:id])
end
#2 respond_to的用法
class ZombiesController < ApplicationController
  def show
    @zombie = Zombie.find(params[:id])

    respond_to do |format|
      fomate.xml { render xml: @zombie }
    end
  end
end
#3 创建的用法 这种方法不好，应该用new而不是create，判断合法才执行
def create
  @zombie = Zombie.create(zombie_params)
  redirect_to zombie_path(@zombie)
end
#4 before_action 的用法
class ZombiesController < ApplicationController
  before_action :find_zombie
  before_action :check_tweets, only: :show

  def show
    render action: :show
  end

  def find_zombie
    @zombie = Zombie.find params[:id]
  end
  
  def check_tweets
    if @zombie.tweets.count == 0
      redirect_to zombies_path
    end
  end
end

#LEVEL 5
#1 路由
TwitterForZombies::Application.routes.draw do
  resources :zombies
end
#2 自定义地址
TwitterForZombies::Application.routes.draw do
  get 'undead' => 'zombies#undead'
end
#3 地址重定向
TwitterForZombies::Application.routes.draw do
  get '/undead', to: redirect('/zombies')
end
#4 根路由
TwitterForZombies::Application.routes.draw do
  root 'zombies#index'
end
#5 地址变量化
TwitterForZombies::Application.routes.draw do
	get '/zombies/:name', to: 'zombies#index', :as => 'graveyard'
end














