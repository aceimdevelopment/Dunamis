# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format
# (all these examples are active by default):
# ActiveSupport::Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end
#
# These inflection rules are supported but not enabled by default:
ActiveSupport::Inflector.inflections do |inflect|
  inflect.clear :all

  # inflect.plural( /$/, 'es')
  # inflect.plural(/z$/i, 'ces')
  # inflect.plural(/([aeiou])$/i, '\1s')
  # 
  # 
  # inflect.singular(/s$/i, '')
  # inflect.singular(/es$/i, '')
  # inflect.singular(/ces$/i, 'z')
  # inflect.singular(/([tj])es$/i, '\1e')
  # inflect.irregular 'clase', 'clases'
  # inflect.irregular 'tipo_clase', 'tipos_clases'
  # inflect.irregular 'mensaje', 'mensajes'
  # inflect.irregular 'tipo_mensaje', 'tipos_mensajes'
  # inflect.irregular 'mensajes', 'mensaje'
  # inflect.irregular 'tipos_mensajes', 'tipo_mensaje'
  
  inflect.plural /([^djlnrs])([A-Z]|_|$)/, '\1s\2'
  inflect.plural /([djlnrs])([A-Z]|_|$)/, '\1es\2'
  inflect.plural /(.*)z([A-Z]|_|$)$/i, '\1ces\2'
  
  inflect.singular /([^djlnrs])s([A-Z]|_|$)/, '\1\2'
  inflect.singular /([djlnrs])es([A-Z]|_|$)/, '\1\2'
  inflect.singular /(.*)ces([A-Z]|_|$)$/i, '\1z\2'
  inflect.irregular 'user', 'users'
  inflect.irregular 'account', 'accounts'
  inflect.irregular 'password', 'passwords'
  inflect.irregular 'session', 'sessions'
  inflect.irregular 'clase', 'clases'
  inflect.irregular 'tipo_clase', 'tipos_clases'
  inflect.irregular 'mensaje', 'mensajes'
  inflect.irregular 'tipo_mensaje', 'tipos_mensajes'
end