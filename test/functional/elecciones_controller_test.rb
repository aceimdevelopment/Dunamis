require 'test_helper'

class EleccionesControllerTest < ActionController::TestCase
  setup do
    @eleccion = elecciones(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:elecciones)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create eleccion" do
    assert_difference('Eleccion.count') do
      post :create, eleccion: { ano: @eleccion.ano, fecha: @eleccion.fecha, nombre: @eleccion.nombre }
    end

    assert_redirected_to eleccion_path(assigns(:eleccion))
  end

  test "should show eleccion" do
    get :show, id: @eleccion
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @eleccion
    assert_response :success
  end

  test "should update eleccion" do
    put :update, id: @eleccion, eleccion: { ano: @eleccion.ano, fecha: @eleccion.fecha, nombre: @eleccion.nombre }
    assert_redirected_to eleccion_path(assigns(:eleccion))
  end

  test "should destroy eleccion" do
    assert_difference('Eleccion.count', -1) do
      delete :destroy, id: @eleccion
    end

    assert_redirected_to elecciones_path
  end
end
