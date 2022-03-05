## StoreIt
StoreIt is an original Ruby on Rails web application,
created as an inventory management solution for individuals or organizations.
...




Set up ruby for your computer.
Set up rails version 6.1.4.1
install yarn using installation instructions on https://yarnpkg.com/getting-started/install
clone store-it github repository
navigate to your store-it local repository
In the ruby commandline console, run: 
```
rails webpacker:install
rails db:migrate
rails db:seed
rails s (or rails server)
```

Running the seed creates items, locations, access groups, and relationships between them.
An administrative user(email: "example@example.com", password: "foobar" and several
 non-administrative users(email: "example-#{n}@example.com", password: "password") are also created.
For best results, log in as the administrative user, or use the commandline rails console to grant your preferred
user administrative privaleges. To easily grant your user admin permissions:
* Retrieve your user
* Run "my_user.set_permissions(UserPermissions::SYS_ADMIN_PERMS)"

* (e.g. "User.find_by(email: #{my_user_email}).set_permissions(UserPermission::SYS_ADMIN_PERMS))