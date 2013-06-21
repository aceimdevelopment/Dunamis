require 'test_helper'

class AsuntosControllerTest < ActionController::TestCase
  setup do
    @asunto = asuntos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:asuntos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create asunto" do
    assert_difference('Asunto.count') do
      post :create, asunto: { descripcion: @asunto.descripcion, nombre: @asunto.nombre }
    end

    assert_redirected_to asunto_path(assigns(:asunto))
  end

  test "should show asunto" do
    get :show, id: @asunto
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @asunto
    assert_response :success
  end

  test "should update asunto" do
    put :update, id: @asunto, asunto: { descripcion: @asunto.descripcion, nombre: @asunto.nombre }
    assert_redirected_to asunto_path(assigns(:asunto))
  end

  test "should destroy asunto" do
    assert_difference('Asunto.count', -1) do
      delete :destroy, id: @asunto
    end

    assert_redirected_to asuntos_path
  end
end
