require 'test_helper'

class WebsitesControllerTest < ActionController::TestCase
  setup do
    @website = websites(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:websites)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create website" do
    assert_difference('Website.count') do
<<<<<<< HEAD
      post :create, website: { descripcion: @website.descripcion, logo: @website.logo, nombre: @website.nombre, url: @website.url }
=======
      post :create, website: { descripcion: @website.descripcion, nombre: @website.nombre, url: @website.url }
>>>>>>> 5c15fe1d515081a9abc7720a1690ba14f4e72998
    end

    assert_redirected_to website_path(assigns(:website))
  end

  test "should show website" do
    get :show, id: @website
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @website
    assert_response :success
  end

  test "should update website" do
<<<<<<< HEAD
    put :update, id: @website, website: { descripcion: @website.descripcion, logo: @website.logo, nombre: @website.nombre, url: @website.url }
=======
    put :update, id: @website, website: { descripcion: @website.descripcion, nombre: @website.nombre, url: @website.url }
>>>>>>> 5c15fe1d515081a9abc7720a1690ba14f4e72998
    assert_redirected_to website_path(assigns(:website))
  end

  test "should destroy website" do
    assert_difference('Website.count', -1) do
      delete :destroy, id: @website
    end

    assert_redirected_to websites_path
  end
end
