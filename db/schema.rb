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

ActiveRecord::Schema.define(:version => 20121113172811) do

  create_table "apariciones", :id => false, :force => true do |t|
    t.integer  "cuna_id",    :null => false
    t.time     "momento",    :null => false
    t.integer  "canal_id",   :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

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

  create_table "cunas", :force => true do |t|
    t.string   "sigecup_id"
    t.date     "sigecup_creacion"
    t.integer  "duracion"
    t.integer  "candidate_id"
    t.string   "video"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "organizacion_id"
  end

  create_table "estados", :force => true do |t|
    t.string   "nombre"
    t.string   "descripcion"
    t.string   "nombre_corto"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "organizaciones", :force => true do |t|
    t.string   "nombre"
    t.string   "descripcion"
    t.string   "nombre_corto"
    t.string   "rif"
    t.integer  "tolda_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "toldas", :force => true do |t|
    t.string   "nombre"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
