require 'test_helper'

class TiposCargosControllerTest < ActionController::TestCase
  setup do
    @tipo_cargo = tipos_cargos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tipos_cargos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tipo_cargo" do
    assert_difference('TipoCargo.count') do
      post :create, tipo_cargo: { nombre: @tipo_cargo.nombre, nombre_corto: @tipo_cargo.nombre_corto }
    end

    assert_redirected_to tipo_cargo_path(assigns(:tipo_cargo))
  end

  test "should show tipo_cargo" do
    get :show, id: @tipo_cargo
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tipo_cargo
    assert_response :success
  end

  test "should update tipo_cargo" do
    put :update, id: @tipo_cargo, tipo_cargo: { nombre: @tipo_cargo.nombre, nombre_corto: @tipo_cargo.nombre_corto }
    assert_redirected_to tipo_cargo_path(assigns(:tipo_cargo))
  end

  test "should destroy tipo_cargo" do
    assert_difference('TipoCargo.count', -1) do
      delete :destroy, id: @tipo_cargo
    end

    assert_redirected_to tipos_cargos_path
  end
end
