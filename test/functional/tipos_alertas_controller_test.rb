require 'test_helper'

class TiposAlertasControllerTest < ActionController::TestCase
  setup do
    @tipo_alerta = tipos_alertas(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tipos_alertas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tipo_alerta" do
    assert_difference('TipoAlerta.count') do
      post :create, tipo_alerta: { descripcion: @tipo_alerta.descripcion }
    end

    assert_redirected_to tipo_alerta_path(assigns(:tipo_alerta))
  end

  test "should show tipo_alerta" do
    get :show, id: @tipo_alerta
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tipo_alerta
    assert_response :success
  end

  test "should update tipo_alerta" do
    put :update, id: @tipo_alerta, tipo_alerta: { descripcion: @tipo_alerta.descripcion }
    assert_redirected_to tipo_alerta_path(assigns(:tipo_alerta))
  end

  test "should destroy tipo_alerta" do
    assert_difference('TipoAlerta.count', -1) do
      delete :destroy, id: @tipo_alerta
    end

    assert_redirected_to tipos_alertas_path
  end
end
