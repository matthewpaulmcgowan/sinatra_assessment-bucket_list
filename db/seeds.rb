@a = User.new(username:"Khine", password: "a")
@a.save
binding.pry
@a.items.create({name: "Climb Kilimanjaro", rank_list: 45, location: "Tanzania", description: "Tallest Mountain in Africa", completed: false})

@b = User.new(username:"Matt", password: "a")
@b.save
@b.items.create({name: "Climb Kilimanjaro", rank_list: 55, location: "Tanzania", description: "", completed: false})

@c = User.new(username:"Madison", password: "a")
@c.save
@c.items.create({name: "climb Kilimanjaro", rank_list: 22, location: "Tanzania", description: "", completed: false})

@d = User.new(username:"Sean", password: "a")
@d.save
@d.items.create({name: "Climb Mt. Fuji", rank_list: 65, location: "Japan", description: "Need to see the sun rise", completed: false})

@e = User.new(username:"Dan", password: "a")
@e.save
@e.items.create({name: "Hang out", rank_list: 88, location: "anywhere", description: "all the time", completed: false})
@e.items.create({name: "Read 1000 books", rank_list: 75, location: "everywhere", description: "Reading is life", completed: false})