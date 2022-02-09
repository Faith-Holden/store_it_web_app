# Create Users
User.create!(name: "Example User",
  email: "example@example.com",
  password: "foobar",
  password_confirmation: "foobar",
  activated: true)

User.first.set_user_permissions(UserPermission::SYS_ADMIN_PERMS)

10.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@example.com"
  password = "password"
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password,
               activated: true)
end

# Create User Permissions
# UserPermission.create!( user_id: 1,
#                         is_sys_admin: true,
#                         can_crud_items: true,
#                         can_crud_access_group_no_parent: true,
#                         can_crud_locations_with_parent: true,
#                         can_crud_locations_no_parent: true)

# 5.times do |n|
#   UserPermission.create!( user_id: n+2,
#                          is_sys_admin: false,
#                          can_crud_items: true,
#                          can_crud_access_group_no_parent: false,
#                          can_crud_locations_with_parent: true,
#                          can_crud_locations_no_parent: true)
# end
# 5.times do |n|
#   UserPermission.create!( user_id: n+7,
#                          is_sys_admin: false,
#                          can_crud_items: false,
#                          can_crud_access_group_no_parent: false,
#                          can_crud_locations_with_parent: true,
#                          can_crud_locations_no_parent: false)
# end


# Create Access Groups
AccessGroup.create!(name: "AG1")
10.times do |n|
  name = "AG#{n+2}"
  AccessGroup.create!(name: name,
                      parent_id: 1)
end

# Create Locations
Location.create!(name: "L1")
10.times do |n|
  name = "L#{n+2}"
  location = Location.create!(name: name,
                             parent_id: 1)
  AccessGroup.first.add_location(location)
end

# Create Items
Item.create!(name: "I1")
10.times do |n|
  name = "I#{n+2}"
  item = Item.create!(name: name)
  AccessGroup.first.add_item(item)
end

# Create UserAccesses
AccessGroup.all.each do |group|
  user = User.first
  access_group = UserAccess.new(user_id: user.id,
                               access_group_id: group.id)
  access_group.set_permissions(UserAccess::SYS_ADMIN_PERMS)
end