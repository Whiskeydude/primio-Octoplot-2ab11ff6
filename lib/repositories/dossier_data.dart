import '../models/game_models.dart';

const Map<String, Dossier> dossierData = {
  'media': Dossier(
    lore: 'Every story begins as a whisper in a newsroom. Own the whisper and you own what the world believes happened.',
    targets: ['Morning wire services', 'Prime-time anchors', 'The viral feed algorithm'],
    bonusName: 'Spin Doctors',
    bonusText: 'All operation suspicion is halved.',
  ),
  'banking': Dossier(
    lore: 'Money has no loyalty, only direction. A few signatures in the right vault turn any rival into a debtor.',
    targets: ['Regional credit unions', 'Clearing houses', 'The central reserve'],
    bonusName: 'Offshore Accounts',
    bonusText: '+6 funds every night.',
  ),
  'tech': Dossier(
    lore: 'Billions of people tell the machines everything. The machines, quietly, tell you.',
    targets: ['Cloud data centres', 'Search ranking team', 'The assistant in every pocket'],
    bonusName: 'Predictive Algorithms',
    bonusText: 'Every operation gains +5 grip.',
  ),
  'politics': Dossier(
    lore: 'Laws are written by whoever shows up with a pen. Your tentacles always show up first.',
    targets: ['City council chambers', 'Lobbyist dinner circuit', 'The cabinet room'],
    bonusName: 'Friendly Legislation',
    bonusText: 'Infiltrate and Takeover cost 25% less.',
  ),
  'pharma': Dossier(
    lore: 'Patents, trials and a very calming pill. Whoever controls the lab controls how the world sleeps.',
    targets: ['Clinical trial boards', 'Patent offices', 'The global supply of sedatives'],
    bonusName: 'Sedative Supply',
    bonusText: 'Lying low removes 25 suspicion instead of 15.',
  ),
  'military': Dossier(
    lore: 'Budgets are secret, bases are remote, and nobody asks questions of people with clearance.',
    targets: ['Procurement offices', 'Remote listening posts', 'The joint chiefs'],
    bonusName: 'Black Ops Cleanup',
    bonusText: 'Whistleblowers are silenced before they can talk.',
  ),
  'weather': Dossier(
    lore: 'A well-timed storm cancels a hearing. A well-timed drought starts a war. Clouds answer to cables now.',
    targets: ['Coastal radar stations', 'Cloud seeding fleets', 'The forecast models'],
    bonusName: 'Storm Cover',
    bonusText: '40% of leaks and whistleblowers are washed away.',
  ),
  'food': Dossier(
    lore: 'Hungry people forget to be suspicious. Control the harvest and the trucks, and calm follows.',
    targets: ['Grain exchanges', 'Supermarket logistics', 'The global seed vault'],
    bonusName: 'Loyal Supply Lines',
    bonusText: 'Suspicion falls 2 extra points every night.',
  ),
  'space': Dossier(
    lore: 'Above every border hangs a satellite that never blinks. Whoever rents the sky sees everything.',
    targets: ['Launch contractors', 'Orbital relay network', 'The moon base charter'],
    bonusName: 'Orbital Shell Companies',
    bonusText: 'Offshore windfalls pay double.',
  ),
  'academia': Dossier(
    lore: 'A rumour with a footnote becomes a fact. Fund the right chair and the footnotes write themselves.',
    targets: ['Student journals', 'Endowed research chairs', 'The peer review cartel'],
    bonusName: 'Peer-Reviewed Rumours',
    bonusText: 'Whisper operations gain double grip.',
  ),
};
