# for loading canned data if needed

# if Items.find().count() is 0
#     items = []

#     for item in items
#         Items.insert(item)

# if Categories.find().count() is 0
#     Categories.insert({
#         name: "Wrist Watches",
#         uid: 0,
#         items: ["aMphQ29K8f22jPrW8", "GyFXCZEruvY8Tehto", "K6cHT83PAy9qHeF9h"]
#     })

# if Meteor.users.find().count() is 0
#     admin = Assets.getText('admin').split(',')

#     Accounts.createUser 
#         username: admin[0]
#         email: admin[1]
#         password: admin[2]
#         profile:
#           first_name: admin[3]
#           last_name: admin[4]