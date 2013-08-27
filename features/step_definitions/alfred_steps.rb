require 'uri'
require 'cgi'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "models", "course.rb"))
#require_relative '../../models/course.rb'


module WithinHelpers
  def with_scope(locator)
    locator ? within(locator) { yield } : yield
  end
end
World(WithinHelpers)


Given(/^the course "(.*?)"$/) do |course_name|
	@course = Course.new
	@course.name = course_name
	@course.active =true
	@course.save
end

Given(/^the teacher "(.*?)"$/) do |teacher_name|
	@account = Account.new_teacher( {:name => teacher_name,
		:surname => "some_surname",
		:email => "#{teacher_name}@someplace.com",
		:buid => 'xxxx',
		:password => 'Passw0rd!',
		:password_confirmation => 'Passw0rd!'})
	@account.courses << @course
	puts @account.save
end

Given(/^I am logged in as teacher$/) do
	visit '/login'
	fill_in(:email, :with => @account.email)
	fill_in(:password, :with => 'Passw0rd!')
	click_button :sign_in
end

Then(/^Log out menu option show be visible$/) do
  page.should have_content 'Salir'
end

When(/^I fill and submit then registration form$/) do
  click_link 'crear cuenta'
	fill_in(:account_name, :with => 'juan')
	fill_in(:account_surname, :with => 'perez')
	fill_in(:account_buid, :with => '78555')
	fill_in(:account_email, :with =>'juan.perez@test.com')
	fill_in(:account_tag, :with => 'mie')
	fill_in(:account_password, :with => 'Passw0rd!')
	fill_in(:account_password_confirmation, :with =>'Passw0rd!')
	click_button 'save'
end