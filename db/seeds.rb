@a = User.new(username:"Khine", password: "a")
@a.save
@a.items << Item.create(name: "Swim to France", rank_list: 45, location: "", description: "", completed: false)

@b = User.new(username:"Matt", password: "a")
@b.save
@b.items << Item.create(name: "Swim to France", rank_list: 76, location: "", description: "", completed: false)

@c = User.new(username:"Madison", password: "a")
@c.save
@c.items << Item.create(name: "swim to france", rank_list: 22, location: "", description: "", completed: false)

@d = User.new(username:"Sean", password: "a")
@d.save
@d.items << Item.create(name: "Defeate Aliens in the inevitable battle for earth", rank_list: 35, location: "", description: "", completed: false)

@e = User.new(username:"Dan", password: "a")
@e.save
@e.items << Item.create(name: "Hang out", rank_list: 99, location: "", description: "", completed: false)
@e.items << Item.create(name:"Go to the movies", rank_list: 44, location: "", description: "", completed: false)