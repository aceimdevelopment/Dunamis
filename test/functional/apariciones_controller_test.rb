require 'test_helper'

class AparicionesControllerTest < ActionController::TestCase
  setup do
    @aparicion = apariciones(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:apariciones)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create aparicion" do
    assert_difference('Aparicion.count') do
      post :create, aparicion: { canal_id: @aparicion.canal_id, cuna_id: @aparicion.cuna_id, momento: @aparicion.momento }
    end

    assert_redirected_to aparicion_path(assigns(:aparicion))
  end

  test "should show aparicion" do
    get :show, id: @aparicion
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @aparicion
    assert_response :success
  end

  test "should update aparicion" do
    put :update, id: @aparicion, aparicion: { canal_id: @aparicion.canal_id, cuna_id: @aparicion.cuna_id, momento: @aparicion.momento }
    assert_redirected_to aparicion_path(assigns(:aparicion))
  end

  test "should destroy aparicion" do
    assert_difference('Aparicion.count', -1) do
      delete :destroy, id: @aparicion
    end

    assert_redirected_to apariciones_path
  end
end
