require 'test_helper'

class CunasControllerTest < ActionController::TestCase
  setup do
    @cuna = cunas(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cunas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cuna" do
    assert_difference('Cuna.count') do
      post :create, cuna: { candidate_id: @cuna.candidate_id, duracion: @cuna.duracion, ordanizacion_id: @cuna.ordanizacion_id, sigecup_creacion: @cuna.sigecup_creacion, sigecup_id: @cuna.sigecup_id, video: @cuna.video }
    end

    assert_redirected_to cuna_path(assigns(:cuna))
  end

  test "should show cuna" do
    get :show, id: @cuna
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @cuna
    assert_response :success
  end

  test "should update cuna" do
    put :update, id: @cuna, cuna: { candidate_id: @cuna.candidate_id, duracion: @cuna.duracion, ordanizacion_id: @cuna.ordanizacion_id, sigecup_creacion: @cuna.sigecup_creacion, sigecup_id: @cuna.sigecup_id, video: @cuna.video }
    assert_redirected_to cuna_path(assigns(:cuna))
  end

  test "should destroy cuna" do
    assert_difference('Cuna.count', -1) do
      delete :destroy, id: @cuna
    end

    assert_redirected_to cunas_path
  end
end
