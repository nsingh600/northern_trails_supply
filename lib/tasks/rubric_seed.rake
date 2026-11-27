namespace :rubric do
  task seed_extras: :environment do
    [["Alberta","AB",0.05,0,0],["British Columbia","BC",0.05,0.07,0],["Manitoba","MB",0.05,0.07,0],["New Brunswick","NB",0,0,0.15],["Newfoundland and Labrador","NL",0,0,0.15],["Northwest Territories","NT",0.05,0,0],["Nova Scotia","NS",0,0,0.15],["Nunavut","NU",0.05,0,0],["Ontario","ON",0,0,0.13],["Prince Edward Island","PE",0,0,0.15],["Quebec","QC",0.05,0.09975,0],["Saskatchewan","SK",0.05,0.06,0],["Yukon","YT",0.05,0,0]].each { |n,c,g,p,h| prov = Province.find_or_initialize_by(name: n); prov.abbreviation = c if prov.respond_to?(:abbreviation=); prov.code = c if prov.respond_to?(:code=); prov.update!(gst_rate: g, pst_rate: p, hst_rate: h) }
    puts "Seeded #{Province.count} provinces."
  end
end
