# -*- coding: utf-8 -*-

r = Role.create
r.name = 'Avdelningsroll 1'
r.category = 'department'
r.homepage_url = 'http://komin.malmo.se'
r.save(validate: false)

r = Role.create
r.name = 'Arbetsfältroll 1'
r.category = 'working_field'
r.homepage_url = 'http://komin.malmo.se'
r.save(validate: false)

u = User.create
u.username = 'user1'
u.displayname = 'user 1'
u.save(validate: false)

u = User.create
u.username = 'admin1'
u.displayname = 'admin 1'
u.admin = true
u.save(validate: false)

@bios = [
  "Semper recusabo eleifend vis ad, ad ipsum delicata nam, nonumy denique mel in. Eu placerat neglegentur eos, ea doctus nominati sit. Facer bonorum fabellas ut mel. Sea no congue senserit, nec ut cetero efficiantur, pri te tritani conceptam reformidans. Cu mea natum urbanitas appellantur.",
  "At albucius volutpat has, utamur lobortis sea an. Dolorem perfecto mea at, postulant gubergren ea nec. Ad qui agam labitur. Has modo eloquentiam ei. Ad bonorum complectitur eos, laoreet mediocritatem an vix. Vidit vocent ei nam, copiosae prodesset cu mei.",
  "Ex habeo expetendis per, in nam facer inani error. Sed quas euripidis ne, an vim ridens nostrum. Quidam dictas ei sea. Splendide efficiendi usu ne, no sit alia disputationi, ea veritus dolorem deterruisset sea. Cu nec discere scaevola intellegebat.",
  "Cu eius iudicabit appellantur nec, dicunt lucilius sea ne. Ei per laudem splendide. Quaeque reformidans sit te, quaeque commune an duo. No est mutat vidisse apeirian, eu ocurreret temporibus vix. Nec tale copiosae maiestatis at, nec ex clita accusam ancillae.",
  "Mucius possim an pro. Ne vim deserunt nominati constituam. Per libris essent ea. Te eam erat gloriatur. At sale vitae quo.",
  "Accusam efficiendi eos ei, no fugit mundi apeirian cum, epicuri voluptua lucilius an eos. Numquam eleifend per at, id clita vituperata adversarium per. His errem dolor cu, facilis nominavi sed ut, soleat efficiendi vim eu. Mei omnium interpretaris te, amet delectus sapientem cu mea. Per eu movet noster neglegentur, ei sed erat dicit conceptam, pro in sumo propriae. Vidit consul vidisse quo ad, nobis mediocrem id quo.",
  "Eam ea inani sonet legere, mea indoctum definitionem id. Eum menandri reformidans accommodare at, amet melius cu cum. Cum ei wisi debitis copiosae, sea accumsan suscipit accusata ne. Pri at omittam indoctum mediocritatem, vero inciderint ea vix.",
  "Vocent voluptua sed no, tacimates interesset duo id, modo deserunt disputationi eam in. Mel et illud nulla, dicunt laboramus an est. Has in legere virtute, vis ea tamquam omittam scaevola, pri etiam falli democritum ex. Omnis minim vulputate ea his, et fugit primis scaevola his.",
  "Eu movet vivendo delicata per, ei nec mundi verterem consequuntur. Delicata iracundia philosophia sea at. In has volumus gloriatur, errem homero tibique ne vis, his perfecto efficiantur te. Quo exerci virtute no.",
  "Ex oblique efficiantur liberavisse vix, sed brute aeterno erroribus cu. Brute urbanitas sed id, et partem necessitatibus duo, debitis adolescens ea vix. Nominavi persecuti ad his. Autem docendi in has, ius et ferri euismod officiis, has cu tale noster doctus. Tale congue soleat ei has."
]

@languages = [
  "Svenska",
  "Danska",
  "Tyska",
  "Spanska",
  "Italienska",
  "Arabiska",
  "Hebreiska",
  "Hindi",
  "Japanska",
  "Isländska"
]

@skills = [
  "Accusam efficiendi",
  "Sonet legere",
  "Movet vivendo",
  "Mucius possim an pro",
  "Libris essent",
  "Dicunt laboramus",
  "Ubergren ea nec"
]

User.all.each do |user|
  user.update_attributes({
    professional_bio: @bios[rand(@bios.size)],
    language_list: (0..rand(3)).map { @languages[rand(@languages.size)] }.uniq.join(", "),
    skill_list: (0..rand(5)).map { @skills[rand(@skills.size)] }.uniq.join(", ")
  })
end
