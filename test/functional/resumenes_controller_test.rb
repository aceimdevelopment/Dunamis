require 'test_helper'

class ResumenesControllerTest < ActionController::TestCase
  setup do
    @resumen = resumenes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:resumenes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create resumen" do
    assert_difference('Resumen.count') do
      post :create, resumen: { contenido: @resumen.contenido, titulo: @resumen.titulo }
    end

    assert_redirected_to resumen_path(assigns(:resumen))
  end

  test "should show resumen" do
    get :show, id: @resumen
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @resumen
    assert_response :success
  end

  test "should update resumen" do
    put :update, id: @resumen, resumen: { contenido: @resumen.contenido, titulo: @resumen.titulo }
    assert_redirected_to resumen_path(assigns(:resumen))
  end

  test "should destroy resumen" do
    assert_difference('Resumen.count', -1) do
      delete :destroy, id: @resumen
    end

    assert_redirected_to resumenes_path
  end
end
