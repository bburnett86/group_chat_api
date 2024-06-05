# frozen_string_literal: true

# The UserSerializer class is responsible for defining how a User object
# should be serialized. This class is typically used when a User object
# needs to be rendered as JSON, for example in an API response.
class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :email, :username, :show_email, :bio, :active, :role, :avatar_url
end
