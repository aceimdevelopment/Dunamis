# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130620171530) do

  create_table "apariciones", :id => false, :force => true do |t|
    t.integer  "cuna_id",    :null => false
    t.datetime "momento",    :null => false
    t.integer  "canal_id",   :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.date     "fecha"
  end

  add_index "apariciones", ["canal_id", "cuna_id", "momento"], :name => "index_apariciones_on_canal_id_and_cuna_id_and_momento", :unique => true
  add_index "apariciones", ["canal_id"], :name => "FK aparicon canal_idx"
  add_index "apariciones", ["cuna_id"], :name => "key aparicion cuna_idx"

  create_table "canales", :force => true do |t|
    t.string   "nombre"
    t.string   "siglas"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "candidates", :force => true do |t|
    t.string   "name",            :null => false
    t.string   "description"
    t.string   "foto"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "organizacion_id"
    t.integer  "estado_id"
  end

  add_index "candidates", ["estado_id"], :name => "key_estados_idx"
  add_index "candidates", ["organizacion_id"], :name => "key_organizaciones_idx"

  create_table "candidates_cunas", :id => false, :force => true do |t|
    t.integer "candidate_id", :null => false
    t.integer "cuna_id",      :null => false
  end

  add_index "candidates_cunas", ["candidate_id", "cuna_id"], :name => "index_candidates_cunas_on_candidate_id_and_cuna_id", :unique => true
  add_index "candidates_cunas", ["candidate_id"], :name => "FK_idx"
  add_index "candidates_cunas", ["cuna_id"], :name => "FK cunas_idx"

  create_table "cunas", :force => true do |t|
    t.string   "sigecup_id",       :null => false
    t.date     "sigecup_creacion"
    t.integer  "duracion"
    t.string   "video"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "organizacion_id"
    t.string   "nombre",           :null => false
    t.string   "grupo"
  end

  add_index "cunas", ["nombre"], :name => "index_cunas_on_nombre", :unique => true
  add_index "cunas", ["organizacion_id"], :name => "key_cunas_organizacion_idx"
  add_index "cunas", ["sigecup_id"], :name => "index_cunas_on_sigecup_id", :unique => true

  create_table "estados", :force => true do |t|
    t.string   "nombre"
    t.string   "descripcion"
    t.string   "nombre_corto"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "estados", ["nombre"], :name => "index_estados_on_nombre", :unique => true

  create_table "organizaciones", :force => true do |t|
    t.string   "nombre"
    t.string   "descripcion"
    t.string   "nombre_corto"
    t.string   "rif"
    t.integer  "tolda_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "tipo_id"
  end

  add_index "organizaciones", ["tipo_id"], :name => "FK tipo_idx"
  add_index "organizaciones", ["tolda_id"], :name => "FK tolda_idx"

  create_table "tipos", :force => true do |t|
    t.string   "nombre",      :null => false
    t.string   "descripcion"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "tipos", ["nombre"], :name => "index_tipos_on_nombre", :unique => true

  create_table "toldas", :force => true do |t|
    t.string   "nombre"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "websites", :force => true do |t|
    t.string   "url"
    t.string   "nombre"
    t.string   "descripcion"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

end
