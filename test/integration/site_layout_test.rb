require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  test 'layout links' do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", login_path
    get signup_path
    assert_select "title", full_title('Signup')
  end
  
  test 'logged-in layout links' do
    log_in_as users(:mach1010)
    follow_redirect!
    assert_template 'users/show'
    get root_path
    assert_select "a[href=?]", users_path
  end
    
end
 