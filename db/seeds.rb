# db/seeds.rb

tenant = Tenant.first
raise "No Tenant found. Create a tenant first." unless tenant

# -------------------------
# BUSINESSES (3)
# -------------------------
businesses_data = [
  {
    name: "Skyline Bowling & Lounge",
    location: "BGC, Taguig City",
    description: "Modern bowling lanes with lounge seating, snacks, and weekend events."
  },
  {
    name: "Harbor Wellness Studio",
    location: "Cebu IT Park, Cebu City",
    description: "Wellness studio offering massage, body therapy, and guided recovery sessions."
  },
  {
    name: "Palm & Pine Event Space",
    location: "Makati City",
    description: "Private event space for birthdays, corporate nights, and intimate celebrations."
  }
]

businesses = businesses_data.map do |attrs|
  Business.find_or_create_by!(tenant_id: tenant.id, name: attrs[:name]) do |b|
    b.location = attrs[:location]
    b.description = attrs[:description]
  end
end

# -------------------------
# SERVICES (belong to business) + PRICE
# -------------------------
services_data = [
  { business: businesses[0], name: "Lane Reservation",        description: "Reserve 1–2 lanes for a time slot.", price: 899 },
  { business: businesses[0], name: "Party Package",           description: "Decor + snacks + lane bundle.",        price: 4999 },
  { business: businesses[0], name: "Corporate Night Bundle",  description: "Team event package + invoice.",       price: 7999 },

  { business: businesses[1], name: "60-min Massage",          description: "Relaxing full body massage.",         price: 1200 },
  { business: businesses[1], name: "90-min Deep Tissue",      description: "Deep tissue + stretch.",             price: 1800 },
  { business: businesses[1], name: "Recovery Session",        description: "Post-workout recovery program.",      price: 1500 },

  { business: businesses[2], name: "Venue Half-day",          description: "4-hour venue rental + basic setup.",  price: 8500 },
  { business: businesses[2], name: "Venue Full-day",          description: "8-hour venue rental + full setup.",   price: 15000 },
  { business: businesses[2], name: "Add-on: Projector + PA",  description: "Projector + speakers + mic.",         price: 2500 }
]

services = services_data.map do |s|
  existing = Service.find_by(business_id: s[:business].id, name: s[:name]) rescue nil

  attrs = { description: s[:description] }
  attrs[:price] = s[:price] if Service.column_names.include?("price")

  if existing
    existing.update!(attrs)
    existing
  else
    create_attrs = {
      business_id: s[:business].id,
      name: s[:name],
      description: s[:description]
    }
    create_attrs[:price] = s[:price] if Service.column_names.include?("price")
    Service.create!(create_attrs)
  end
end

# -------------------------
# CUSTOMERS (more + phone)
# -------------------------
customers_data = [
  { name: "Mika Reyes",        phone: "+63 917 111 2233" },
  { name: "Jared Santos",      phone: "+63 918 222 3344" },
  { name: "Alyssa Cruz",       phone: "+63 919 333 4455" },
  { name: "Kenji Tanaka",      phone: "+63 920 444 5566" },
  { name: "Bianca Flores",     phone: "+63 921 555 6677" },
  { name: "Noah Lim",          phone: "+63 922 666 7788" },
  { name: "Sofia Dela Peña",   phone: "+63 923 777 8899" },
  { name: "Paolo Navarro",     phone: "+63 924 888 9900" },
  { name: "Andrea Villanueva", phone: "+63 925 101 2020" },
  { name: "Marco Bautista",    phone: "+63 926 303 4040" },
  { name: "Elaine Ramos",      phone: "+63 927 505 6060" },
  { name: "Troy Garcia",       phone: "+63 928 707 8080" },
  { name: "Ivy Mendoza",       phone: "+63 929 909 1010" },
  { name: "Hannah Uy",         phone: "+63 930 111 1212" },
  { name: "Daniel Chua",       phone: "+63 931 131 1414" },
  { name: "Carla Domingo",     phone: "+63 932 151 1616" }
]

customers = customers_data.map do |c|
  # If phone column doesn't exist yet, we fall back to name-only.
  if Customer.column_names.include?("phone")
    Customer.find_or_create_by!(name: c[:name]) { |x| x.phone = c[:phone] }
  else
    Customer.find_or_create_by!(name: c[:name])
  end
end

# Users (optional) — assign if you have users
users = User.limit(6).to_a
def pick(arr) = arr.sample

# Helper: pick a service from a given business
services_by_business = services.group_by(&:business_id)

# -------------------------
# BOOKINGS (MUST have business_id)
# -------------------------
today = Date.current
this_week_start = today.beginning_of_week
this_week_end = today.end_of_week
next_week_start = today.next_week.beginning_of_week
next_week_end = today.next_week.end_of_week

bookings_data = [
  { business: businesses[0], name: "Lane Reservation - Saturday Night", description: "2 lanes reserved. Shoe rental for 6 pax.", from: Date.new(2026, 2, 12), to: Date.new(2026, 2, 12), duration: 90,  status: :created },
  { business: businesses[0], name: "Birthday Party Booking",            description: "Party setup + snacks. Confirm guest list 24h before.", from: Date.new(2026, 2, 16), to: Date.new(2026, 2, 16), duration: 180, status: :not_finish },
  { business: businesses[0], name: "Corporate Team Night",              description: "Company event. Needs invoice + attendee list.", from: Date.new(2026, 2, 20), to: Date.new(2026, 2, 20), duration: 120, status: :created },
  { business: businesses[0], name: "League Practice Session",           description: "Practice session. Prepare score sheets.", from: Date.new(2026, 3, 8),  to: Date.new(2026, 3, 8),  duration: 90,  status: :not_finish },

  { business: businesses[1], name: "60-min Massage Session",            description: "Afternoon slot preferred. Light pressure.", from: Date.new(2026, 2, 23), to: Date.new(2026, 2, 23), duration: 60,  status: :finished },
  { business: businesses[1], name: "90-min Deep Tissue",                description: "Focus shoulders/lower back. Prior injury noted.", from: Date.new(2026, 2, 26), to: Date.new(2026, 2, 26), duration: 90,  status: :created },
  { business: businesses[1], name: "Recovery Session - Post Workout",   description: "Medium pressure + stretching.", from: Date.new(2026, 3, 10), to: Date.new(2026, 3, 10), duration: 75, status: :not_finish },
  { business: businesses[1], name: "Massage Session - Relax",           description: "Quiet room request. No oils with strong scent.", from: Date.new(2026, 3, 12), to: Date.new(2026, 3, 12), duration: 60, status: :created },

  { business: businesses[2], name: "Event Space Half-day",              description: "Birthday celebration. Needs projector + extra chairs.", from: Date.new(2026, 3, 1),  to: Date.new(2026, 3, 1),  duration: 240, status: :not_finish },
  { business: businesses[2], name: "Event Space Full-day",              description: "Corporate training. Early access for setup.", from: Date.new(2026, 3, 5),  to: Date.new(2026, 3, 5),  duration: 480, status: :created },
  { business: businesses[2], name: "Workshop Rental Half-day",          description: "Small workshop. Needs PA system + water station.", from: Date.new(2026, 3, 7),  to: Date.new(2026, 3, 7),  duration: 240, status: :created },
  { business: businesses[2], name: "Evening Social Event",              description: "Cocktail setup + projector. Confirm final headcount.", from: Date.new(2026, 3, 14), to: Date.new(2026, 3, 14), duration: 300, status: :not_finish },

  { business: businesses[0], name: "Weekend Bowl & Bite",               description: "Family package + snack bundle. Prefer early slot.", from: Date.new(2026, 3, 21), to: Date.new(2026, 3, 21), duration: 120, status: :created },
  { business: businesses[0], name: "Corporate League Tryout",           description: "Reserve 3 lanes. Need scoreboard printout.", from: Date.new(2026, 3, 25), to: Date.new(2026, 3, 25), duration: 150, status: :not_finish },
  { business: businesses[0], name: "Kids Bowling Clinic",               description: "Kids group. Provide light balls + bumpers.", from: Date.new(2026, 4, 2),  to: Date.new(2026, 4, 2),  duration: 90,  status: :created },
  { business: businesses[0], name: "Friday Night Glow Bowl",            description: "Glow mode + playlist. 2 lanes.", from: Date.new(2026, 4, 4),  to: Date.new(2026, 4, 4),  duration: 120, status: :finished },

  { business: businesses[1], name: "Sports Recovery Session",           description: "Focus calves + hamstrings. Medium pressure.", from: Date.new(2026, 3, 18), to: Date.new(2026, 3, 18), duration: 75,  status: :created },
  { business: businesses[1], name: "Couples Massage",                   description: "Two therapists requested. Side-by-side setup.", from: Date.new(2026, 3, 22), to: Date.new(2026, 3, 22), duration: 90,  status: :not_finish },
  { business: businesses[1], name: "Wellness Check-in",                 description: "Light session + posture review.", from: Date.new(2026, 3, 28), to: Date.new(2026, 3, 28), duration: 45,  status: :created },
  { business: businesses[1], name: "Late Afternoon Relax",              description: "Aromatherapy (lavender).", from: Date.new(2026, 4, 6),  to: Date.new(2026, 4, 6),  duration: 60,  status: :finished },

  { business: businesses[2], name: "Photo Shoot Block",                 description: "Backdrop + lighting. Quiet setup.", from: Date.new(2026, 3, 19), to: Date.new(2026, 3, 19), duration: 180, status: :created },
  { business: businesses[2], name: "Boardroom Setup",                   description: "U-shape seating + HDMI projector.", from: Date.new(2026, 3, 27), to: Date.new(2026, 3, 27), duration: 240, status: :not_finish },
  { business: businesses[2], name: "Community Meetup",                  description: "Sign-in desk + water station.", from: Date.new(2026, 4, 3),  to: Date.new(2026, 4, 3),  duration: 210, status: :created },
  { business: businesses[2], name: "Product Launch Night",              description: "Stage + lighting. Extra chairs.", from: Date.new(2026, 4, 10), to: Date.new(2026, 4, 10), duration: 360, status: :finished },

  { business: businesses[0], name: "Today: Family Lane Time",           description: "Two lanes, shoe rental for 4.", from: today, to: today, duration: 120, status: :created },
  { business: businesses[1], name: "Today: Recovery Quick Session",      description: "Short recovery + stretch.", from: today, to: today, duration: 45, status: :not_finish },
  { business: businesses[2], name: "Today: Event Walkthrough",           description: "Walkthrough + layout planning.", from: today, to: today, duration: 60, status: :created },

  { business: businesses[0], name: "Next Week: Lane League Night",       description: "Reserve 3 lanes. Keep scores.", from: next_week_start + 1.day, to: next_week_start + 1.day, duration: 150, status: :created },
  { business: businesses[1], name: "Next Week: Deep Tissue Follow-up",   description: "Focus on shoulders and back.", from: next_week_start + 2.days, to: next_week_start + 2.days, duration: 90, status: :not_finish },
  { business: businesses[2], name: "Next Week: Workshop Setup",          description: "AV check + seating layout.", from: next_week_start + 3.days, to: next_week_start + 3.days, duration: 180, status: :created },
  { business: businesses[0], name: "Ends Next Week: Weekend Package",    description: "Booking spans into next week.", from: this_week_end, to: next_week_start + 1.day, duration: 240, status: :not_finish },
  { business: businesses[1], name: "Ends Next Week: Wellness Plan",      description: "Multi-day wellness booking.", from: next_week_start, to: next_week_end - 1.day, duration: 300, status: :created },
  { business: businesses[2], name: "Ends Next Week: Corporate Setup",    description: "Setup + teardown window.", from: next_week_start + 1.day, to: next_week_end, duration: 360, status: :created }
]

bookings_data.each_with_index do |b, idx|
  biz = b[:business]
  svc = services_by_business[biz.id]&.sample
  raise "No services for business #{biz.name} (id=#{biz.id})" unless svc

  attrs = {
    name: b[:name],
    description: b[:description],
    from: b[:from],
    to: b[:to],
    duration: b[:duration],
    status: b[:status],
    business_id: biz.id,
    service_id: svc.id,
    customer_id: customers[idx % customers.length].id
  }

  # Assign a user if your column exists (user_id or assigned_to_id)
  if Booking.column_names.include?("assigned_to_id")
    attrs[:assigned_to_id] = users.any? ? pick(users).id : nil
  elsif Booking.column_names.include?("user_id")
    attrs[:user_id] = users.any? ? pick(users).id : nil
  end

  Booking.create!(attrs)
end

puts "✅ Seeded tenant=#{tenant.id} | businesses=#{businesses.size} | services=#{services.size} | customers=#{customers.size} | bookings=#{bookings_data.size}"
