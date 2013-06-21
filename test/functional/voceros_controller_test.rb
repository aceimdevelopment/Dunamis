require 'test_helper'

class VocerosControllerTest < ActionController::TestCase
  setup do
    @vocero = voceros(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:voceros)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create vocero" do
    assert_difference('Vocero.count') do
      post :create, vocero: { descripcion: @vocero.descripcion, foto: @vocero.foto, nombre: @vocero.nombre }
    end

    assert_redirected_to vocero_path(assigns(:vocero))
  end

  test "should show vocero" do
    get :show, id: @vocero
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @vocero
    assert_response :success
  end

  test "should update vocero" do
    put :update, id: @vocero, vocero: { descripcion: @vocero.descripcion, foto: @vocero.foto, nombre: @vocero.nombre }
    assert_redirected_to vocero_path(assigns(:vocero))
  end

  test "should destroy vocero" do
    assert_difference('Vocero.count', -1) do
      delete :destroy, id: @vocero
    end

    assert_redirected_to voceros_path
  end
end
