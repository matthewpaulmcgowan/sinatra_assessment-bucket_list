@a = User.new(username:"Khine", password: "a")
@a.save
binding.pry
@a.items.create({name: "Swim to France", rank_list: 45, location: "", description: "", completed: false, user_id: @a.id})

@b = User.new(username:"Matt", password: "a")
@b.save
@b.items.create({name: "Swim to France", rank_list: 55, location: "", description: "", completed: false, user_id: @b.id})

@c = User.new(username:"Madison", password: "a")
@c.save
@c.items.create({name: "swim to France", rank_list: 22, location: "", description: "", completed: false, user_id: @c.id})

@d = User.new(username:"Sean", password: "a")
@d.save
@d.items.create({name: "Defeat the aliens", rank_list: 65, location: "", description: "", completed: false, user_id: @d.id})

@e = User.new(username:"Dan", password: "a")
@e.save
@e.items.create({name: "Hang out", rank_list: 88, location: "", description: "", completed: false, user_id: @e.id})
@e.items.create({name: "Walk to France", rank_list: 75, location: "", description: "", completed: false, user_id: @e.id})