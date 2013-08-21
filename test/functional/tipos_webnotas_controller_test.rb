require 'test_helper'

class TiposWebnotasControllerTest < ActionController::TestCase
  setup do
    @tipo_webnota = tipos_webnotas(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tipos_webnotas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tipo_webnota" do
    assert_difference('TipoWebnota.count') do
      post :create, tipo_webnota: { div_contenido: @tipo_webnota.div_contenido, div_fecha: @tipo_webnota.div_fecha, div_imagen: @tipo_webnota.div_imagen, div_nota: @tipo_webnota.div_nota, div_titulo: @tipo_webnota.div_titulo }
    end

    assert_redirected_to tipo_webnota_path(assigns(:tipo_webnota))
  end

  test "should show tipo_webnota" do
    get :show, id: @tipo_webnota
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tipo_webnota
    assert_response :success
  end

  test "should update tipo_webnota" do
    put :update, id: @tipo_webnota, tipo_webnota: { div_contenido: @tipo_webnota.div_contenido, div_fecha: @tipo_webnota.div_fecha, div_imagen: @tipo_webnota.div_imagen, div_nota: @tipo_webnota.div_nota, div_titulo: @tipo_webnota.div_titulo }
    assert_redirected_to tipo_webnota_path(assigns(:tipo_webnota))
  end

  test "should destroy tipo_webnota" do
    assert_difference('TipoWebnota.count', -1) do
      delete :destroy, id: @tipo_webnota
    end

    assert_redirected_to tipos_webnotas_path
  end
end
