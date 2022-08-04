class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :description, :status, :admin
end
