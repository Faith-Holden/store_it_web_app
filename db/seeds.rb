# Create Users
User.create!(name: "Example User",
  email: "example@example.com",
  password: "foobar",
  password_confirmation: "foobar",
  activated: true)

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
UserPermission.create!( user_id: 1,
                        is_sys_admin: true,
                        can_crud_items: true,
                        can_crud_access_group_no_parent: true,
                        can_crud_locations_with_parent: true,
                        can_crud_locations_no_parent: true)

5.times do |n|
  UserPermission.create!( user_id: n+2,
                         is_sys_admin: false,
                         can_crud_items: true,
                         can_crud_access_group_no_parent: false,
                         can_crud_locations_with_parent: true,
                         can_crud_locations_no_parent: true)
end
5.times do |n|
  UserPermission.create!( user_id: n+7,
                         is_sys_admin: false,
                         can_crud_items: false,
                         can_crud_access_group_no_parent: false,
                         can_crud_locations_with_parent: true,
                         can_crud_locations_no_parent: false)
end


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
  Location.create!(name: name,
                      parent_id: 1)
end

# Create UserAccesses
5.times do |n|
  User.first.access_groups<<AccessGroup.find_by(id: n+1)
  new_access = UserAccess.find_by(id: n+1)
  new_access.update_columns( group_admin: true,
                          can_crud_group: true,
                          can_crud_user_access: true,
                          can_crud_subgroups: true,
                          can_crud_item_access: true,
                          can_crud_location_access: true)
end