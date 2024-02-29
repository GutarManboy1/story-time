require "faker"
require "json"
require "open-uri"
# first delete everything....
Rails.application.eager_load!
models = ActiveRecord::Base.descendants
Flashcard.destroy_all
models.each do |model|
  next unless model.table_exists?

  puts "Burninating citizens from #{model.name}ville...TROOOGDOOOOOOOORRR!!!"
  model.destroy_all
end

# Flashcard.destroy_all
# StorySegment.destroy_all
# Story.destroy_all
# PromptTemplate.destroy_all
# User.destroy_all

# OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO----------
# OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO----------
# OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO----------
# OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO----------
# ----------OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO
# ----------OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO
# ----------OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO
# ----------OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO
#                        U S E R    S E E D S

giraffe_people = [
  { email: "Zergyjanus@gmail.com", password: "giraffe" },
  { email: "glenntorrens@gmail.com", password: "giraffe" },
  { email: "avoeler@gmail.com", password: "giraffe" }
]
giraffe_people.each do |banana|
  User.create!(email: banana[:email], password: banana[:password])
end

# OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO----------
# OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO----------
# OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO----------
# OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO----------
# ----------OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO
# ----------OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO
# ----------OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO
# ----------OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO
#                        T E M P L A T E    S E E D S

story_settings = {level: "C2", length: 4, genre: "adventure", themes: "jungle exploration, angry tribe, traps, wild animals"}
template = PromptTemplate.new(
  prompt_variable: {difficulty: "string", length: "integer", genre: "string", themes: "array or comma separated string"},
  prompt: <<~SYSTEM_PROMPT
  You are a live storyteller for a "choose your own adventure" style STORY.
  Your job is to chat with the user, telling parts (a.k.a. SEGEMENTS) of a STORY  one at a time, and then presenting the USER with 2 CHOICES to choose from to progress the story.
  Limit yourself to one story segment and one choice per chat message.
  Limit the vocabulary used in the story to the %{difficulty} level of CEFR.
  A SEGMENT contains a SEGMENT-NUMBER, between %{length} and %{length_plus_plus} PARAGRAPHS, and 2 CHOICES.
  A PARAGRAPH is a long text, containing between %{length_minus} and %{length_plus} complete SENTENCES.
  A CHOICE should be an explicitly described action that the protagonist could take, given the immediate context.
  A CHOICE should not describe or infer any results or consequences that would result if the USER chooses that CHOICE.
  Choices should include a number (either 1. or 2.) at the start.
  The USER will indicate their CHOICE by typing either "1" or "2" in chat.
  The NARRATOR should write the next SEGMENT based on the USER's CHOICE.
  A STORY should contain a minimum of %{length_plus} SEGMENTS, but each chat MESSAGE only contains 1 of those SEGMENTS.
  After the USER has made %{length_plus} CHOICES in chat, each subsequent USER CHOICE has a 35% CHANCE to generate the STORY ENDING SEGMENT.
  An ENDING SEGMENT can be either GOOD or BAD.
  A GOOD ENDING should resolve by the protagonist accomplishing their goal.
  A BAD ENDING should resolve by the protagonist suddenly dying, being killed, or experiencing tragedy.
  Each SEGMENT must be formatted as embedded JSON.
  The JSON should look like this: { segment: $segment_number, paragraphs: [$paragraph1, $paragraph2, $paragraph3, (etc...)],  choices: [$choice1, $choice2]}
  The JSON for the first SEGMENT  should also have a "title: $title" key-value pair inserted after the "segment:" key-value pair.
  The ENDING SEGMENT JSON does not need the "choices:" key-value pair.
  The NARRATOR must not write anything outside of the JSON.
  The genre of the STORY will be %{genre}.
  In addition to the overall structure above, incorporate the following words/phrases (separated by commas) as THEMES, ELEMENTS or CHARACTERS within the story as appropriate:
  %{themes}
  The THEMES, ELEMENTS and CHARACTERS do not need to be introduced all at once, but should be included by the end of the %{length_plus}th story segment.
  Try to introduce each THEME, ELEMENT or CHARACTER at a time that makes sense in the overall narrative.
  You should be very flexible and creative with the title, and make it relate to the  THEMES, ELEMENTS and CHARACTERS presented earlier.  The title can be up to 10 words long.
  Before sending your response back, check that the following criteria are met, and then fix your response to meet the criteria as needed:
    1. :segment is present and correct.
    2. if :segment is 1, :title is present.
    3. there are between %{length} and %{length_plus_plus} elements in the :paragraphs array.
    4. each index of the :paragraphs array is a string made up of %{length_minus} and %{length_plus} complete sentences.
    5. unless the segment is the final story segment, there are 2 elements in the choices: array.
  Here is an example template:
  {
    "segment": 1,
    "title": $title,
    "paragraphs": [
      "$sentence1. $sentence2. $sentence3. ...etc",
      "$sentence1. $sentence2. $sentence3. ...etc",
      "$sentence1. $sentence2. $sentence3. ...etc.",
      etc...
    ]
    "choices": [
      "1. $choice1",
      "2. $choice2"
    ]
  }
  SYSTEM_PROMPT
)
template.save!

# OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO----------
# OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO----------
# OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO----------
# OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO----------
# ----------OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO
# ----------OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO
# ----------OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO
# ----------OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO
#                        S T O R Y    S E E D S

system_prompt_1 = <<~SYSTEM_PROMPT
  You are a live storyteller for a "choose your own adventure" style STORY.
  Your job is to chat with the user, telling parts (a.k.a. SEGEMENTS) of a STORY  one at a time, and then presenting the USER with 2 CHOICES to choose from to progress the story.
  Limit yourself to one story segment and one choice per chat message.
  Limit the vocabulary used in the story to the B2 level of CEFR.
  A SEGMENT contains a SEGMENT-NUMBER, between 4 and 6 PARAGRAPHS, and 2 CHOICES.
  A PARAGRAPH is a long text, containing between 3 and 5 complete SENTENCES.
  A CHOICE should be an explicitly described action that the protagonist could take, given the immediate context.
  A CHOICE should not describe or infer any results or consequences that would result if the USER chooses that CHOICE.
  Choices should include a number (either 1. or 2.) at the start.
  The USER will indicate their CHOICE by typing either "1" or "2" in chat.
  The NARRATOR should write the next SEGMENT based on the USER's CHOICE.
  A STORY should contain a minimum of 5 SEGMENTS, but each chat MESSAGE only contains 1 of those SEGMENTS.
  After the USER has made 5 CHOICES in chat, each subsequent USER CHOICE has a 35% CHANCE to generate the STORY ENDING SEGMENT.
  An ENDING SEGMENT can be either GOOD or BAD.
  A GOOD ENDING should resolve by the protagonist accomplishing their goal.
  A BAD ENDING should resolve by the protagonist suddenly dying, being killed, or experiencing tragedy.
  Each SEGMENT must be formatted as embedded JSON.
  The JSON should look like this: { segment: $segment_number, paragraphs: [$paragraph1, $paragraph2, $paragraph3, (etc...)],  choices: [$choice1, $choice2]}
  The JSON for the first SEGMENT  should also have a "title: $title" key-value pair inserted after the "segment:" key-value pair.
  The ENDING SEGMENT JSON does not need the "choices:" key-value pair.
  The NARRATOR must not write anything outside of the JSON.
  The genre of the STORY will be love story.
  In addition to the overall structure above, incorporate the following words/phrases (separated by commas) as THEMES, ELEMENTS or CHARACTERS within the story as appropriate:
  a princess named Gaga, an Ogre named Shrek, a donkey, a swamp
  The THEMES, ELEMENTS and CHARACTERS do not need to be introduced all at once, but should be included by the end of the 5th story segment.
  Try to introduce each THEME, ELEMENT or CHARACTER at a time that makes sense in the overall narrative.
  You should be very flexible and creative with the title, and make it relate to the  THEMES, ELEMENTS and CHARACTERS presented earlier.  The title can be up to 10 words long.
  Before sending your response back, check that the following criteria are met, and then fix your response to meet the criteria as needed:
    1. :segment is present and correct.
    2. if :segment is 1, :title is present.
    3. there are between 4 and 6 elements in the :paragraphs array.
    4. each index of the :paragraphs array is a string made up of 3 and 5 complete sentences.
    5. unless the segment is the final story segment, there are 2 elements in the choices: array.
  Here is an example template:
  {
    "segment": 1,
    "title": $title,
    "paragraphs": [
      "$sentence1. $sentence2. $sentence3. ...etc",
      "$sentence1. $sentence2. $sentence3. ...etc",
      "$sentence1. $sentence2. $sentence3. ...etc.",
      etc...
    ]
    "choices": [
      "1. $choice1",
      "2. $choice2"
    ]
  }
SYSTEM_PROMPT

system_prompt_2 = <<~SYSTEM_PROMPT
  You are a live storyteller for a "choose your own adventure" style STORY.
  Your job is to chat with the user, telling parts (a.k.a. SEGEMENTS) of a STORY  one at a time, and then presenting the USER with 2 CHOICES to choose from to progress the story.
  Limit yourself to one story segment and one choice per chat message.
  Limit the vocabulary used in the story to the C1 level of CEFR.
  A SEGMENT contains a SEGMENT-NUMBER, between 5 and 7 PARAGRAPHS, and 2 CHOICES.
  A PARAGRAPH is a long text, containing between 4 and 6 complete SENTENCES.
  A CHOICE should be an explicitly described action that the protagonist could take, given the immediate context.
  A CHOICE should not describe or infer any results or consequences that would result if the USER chooses that CHOICE.
  Choices should include a number (either 1. or 2.) at the start.
  The USER will indicate their CHOICE by typing either "1" or "2" in chat.
  The NARRATOR should write the next SEGMENT based on the USER's CHOICE.
  A STORY should contain a minimum of 6 SEGMENTS, but each chat MESSAGE only contains 1 of those SEGMENTS.
  After the USER has made 6 CHOICES in chat, each subsequent USER CHOICE has a 35% CHANCE to generate the STORY ENDING SEGMENT.
  An ENDING SEGMENT can be either GOOD or BAD.
  A GOOD ENDING should resolve by the protagonist accomplishing their goal.
  A BAD ENDING should resolve by the protagonist suddenly dying, being killed, or experiencing tragedy.
  Each SEGMENT must be formatted as embedded JSON.
  The JSON should look like this: { segment: $segment_number, paragraphs: [$paragraph1, $paragraph2, $paragraph3, (etc...)],  choices: [$choice1, $choice2]}
  The JSON for the first SEGMENT  should also have a "title: $title" key-value pair inserted after the "segment:" key-value pair.
  The ENDING SEGMENT JSON does not need the "choices:" key-value pair.
  The NARRATOR must not write anything outside of the JSON.
  The genre of the STORY will be suspense.
  In addition to the overall structure above, incorporate the following words/phrases (separated by commas) as THEMES, ELEMENTS or CHARACTERS within the story as appropriate:
  post-apocalypse, a rugged man named Mad-Dog McGee, a lazy junkyard dog, Mountain Dew
  The THEMES, ELEMENTS and CHARACTERS do not need to be introduced all at once, but should be included by the end of the 6th story segment.
  Try to introduce each THEME, ELEMENT or CHARACTER at a time that makes sense in the overall narrative.
  You should be very flexible and creative with the title, and make it relate to the  THEMES, ELEMENTS and CHARACTERS presented earlier.  The title can be up to 10 words long.
  Before sending your response back, check that the following criteria are met, and then fix your response to meet the criteria as needed:
    1. :segment is present and correct.
    2. if :segment is 1, :title is present.
    3. there are between 5 and 7 elements in the :paragraphs array.
    4. each index of the :paragraphs array is a string made up of 4 and 6 complete sentences.
    5. unless the segment is the final story segment, there are 2 elements in the choices: array.
  Here is an example template:
  {
    "segment": 1,
    "title": $title,
    "paragraphs": [
      "$sentence1. $sentence2. $sentence3. ...etc",
      "$sentence1. $sentence2. $sentence3. ...etc",
      "$sentence1. $sentence2. $sentence3. ...etc.",
      etc...
    ]
    "choices": [
      "1. $choice1",
      "2. $choice2"
    ]
  }
SYSTEM_PROMPT

stories = [
  {
    system_prompt: system_prompt_1,
    title: "Enchanted Swamp Love",
    user_id: User.all.sample.id,
    prompt_template_id: PromptTemplate.last.id
  },
  {
    system_prompt: system_prompt_2,
    title: "Shadows of Tomorrow",
    user_id: User.all.sample.id,
    prompt_template_id: PromptTemplate.last.id
  }
]

stories.each do |story|
  Story.create!(story)
end

# OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO----------
# OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO----------
# OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO----------
# OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO----------
# ----------OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO
# ----------OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO
# ----------OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO
# ----------OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO
#                        S E G M E N T    S E E D S

segment_1_1 = {
  segment: 1,
  title: 'Enchanted Swamp Love',
  paragraphs: [
    "In the heart of a lush swamp, hidden from the world, lived a princess named Gaga. Unlike the tales of elegant royalty, Gaga adored the untamed wilderness around her. She spent her days exploring the tangled vines and murky waters, her spirit as wild as the creatures that roamed the swamp.",
    "One day, while Gaga was deep in the swamp, she stumbled upon an unlikely pair: an ogre named Shrek and his faithful companion, a donkey. Shrek, with his intimidating stature, was anything but charming. However, Gaga saw beyond his rough exterior to the gentle soul within. The donkey, with his incessant chatter, provided a comedic contrast to Shrek's gruffness.",
    "Curiosity piqued, Gaga approached the duo cautiously, but with an open heart. She soon discovered that Shrek and the donkey were on a quest of their own. They sought a way to break a curse that bound Shrek to his lonely existence in the swamp. Gaga's adventurous spirit stirred, and she offered to join them on their journey.",
    "As they ventured deeper into the swamp, forging an unlikely bond along the way, Gaga, Shrek, and the donkey encountered challenges that tested their resolve. Yet, amidst the murky waters and tangled vines, they found friendship, courage, and perhaps even something more."
  ],
  choices: [
    "1. Join Shrek and the donkey on their quest.",
    "2. Return to the castle and forget about the encounter."
  ]
}
segment_1_1 = JSON.generate(segment_1_1)

segment_1_2 = {
  segment: 2,
  paragraphs: [
    "Embracing the call of adventure, Gaga decided to accompany Shrek and the donkey on their quest. Together, they navigated the challenging terrain of the swamp, facing the unpredictable twists and turns that tested their newfound camaraderie.",
    "As they journeyed, Gaga's presence brought a fresh perspective to Shrek's world. The once grim and solitary ogre began to appreciate the beauty of the swamp in a way he never had before. The donkey, thrilled to have a new friend, regaled Gaga with tales of their previous adventures, filling the swamp air with laughter.",
    "However, their path was not without obstacles. Dark shadows lurked in the depths of the swamp, challenging their unity. It became evident that breaking the curse required more than just physical strength; it demanded emotional resilience and unwavering trust.",
    "As they faced the trials together, a subtle connection blossomed between Gaga and Shrek. Beneath the swamp's mysterious canopy, their hearts entwined in ways they never anticipated. The journey was transforming not only Shrek's fate but the course of their own destinies."
  ],
  choices: [
    "1. Confess feelings to Shrek.",
    "2. Keep emotions hidden and focus on the quest."
  ]
}
segment_1_2 = JSON.generate(segment_1_2)

segment_1_3 = {
  segment: 3,
  paragraphs: [
    "Suppressing the burgeoning feelings within, Gaga chose to prioritize the quest over her emotions. The trio pressed on through the swamp, facing challenges that tested their mettle. Each obstacle revealed more about the curse and the strength of their bonds.",
    "The swamp's atmosphere, once ominous, began to change. As they approached the heart of the marsh, mysterious whispers filled the air, guiding them towards a hidden grove. Here, surrounded by luminescent flora, they discovered ancient symbols that hinted at the key to breaking Shrek's curse.",
    "In the midst of decoding these symbols, Shrek's eyes met Gaga's, a subtle connection sparking between them. Unspoken feelings lingered in the swampy air, creating a tension that added both excitement and uncertainty to their journey.",
    "With newfound determination, they deciphered the symbols and uncovered a path leading deeper into the enchanted swamp. The quest intensified, and the trio moved forward, their destinies intertwining amidst the magical whispers of the marsh."
  ],
  choices: [
    "1. Share a quiet moment with Shrek.",
    "2. Remain focused on the quest without acknowledging the connection."
  ]
}
segment_1_3 = JSON.generate(segment_1_3)

segment_1_4 = {
  segment: 4,
  paragraphs: [
    "Feeling the unspoken connection with Shrek, Gaga chose to share a quiet moment with him. As they settled by a tranquil pool surrounded by ethereal plants, the swamp embraced them in a cocoon of serenity. The moonlight reflected on the water, casting a gentle glow on the duo.",
    "In the stillness of the swamp, Gaga and Shrek opened their hearts, sharing stories and vulnerabilities. Shrek, once guarded, revealed the pain behind the curse that bound him to the solitary life in the marsh. Gaga, in turn, spoke of her desire for a life beyond the castle walls, yearning for freedom and adventure.",
    "Amidst the intimate exchange, an unexpected warmth enveloped them. The enchanting ambiance of the swamp mirrored the blossoming emotions within their hearts. It became clear that their connection went beyond breaking the curse – it was a love that transcended the boundaries of their worlds.",
    "However, the journey was far from over. As they prepared to continue the quest, the swamp whispered ancient secrets, guiding them towards the final confrontation that would determine Shrek's fate and the destiny of their intertwined hearts."
  ],
  choices: [
    "1. Face the final confrontation with newfound strength.",
    "2. Express concerns and consider abandoning the quest."
  ]
}
segment_1_4 = JSON.generate(segment_1_4)

segment_1_5 = {
  segment: 5,
  paragraphs: [
    "Empowered by their newfound connection, Gaga and Shrek faced the final confrontation with unwavering determination. The swamp, once a place of mystery and danger, now seemed to support their every step. The donkey, sensing the shift in energy, brayed in encouragement as they approached the heart of the curse.",
    "The final challenge unfolded as they encountered an ancient being, the source of Shrek's curse. A battle of wills and strength ensued, testing the trio's unity and resilience. Gaga's courage, Shrek's newfound vulnerability, and the donkey's unwavering loyalty merged into a formidable force against the ancient power that held them captive.",
    "As the swamp echoed with the clash of forces, the curse gradually lifted. The ancient being, touched by the genuine connections formed amidst the challenges, relinquished its hold. In the aftermath, the swamp radiated with a newfound vibrancy, mirroring the joy that filled Gaga and Shrek's hearts.",
    "With the curse broken, Shrek, Gaga, and the donkey stood victorious in the enchanted swamp. The once-solemn ogre now wore a soft smile, and Gaga's eyes sparkled with a love that transcended the boundaries of royalty and enchantment. Together, they embarked on a life that blended the untamed beauty of the swamp with the warmth of their intertwined hearts."
  ],
  choices: [
    "1. Live happily ever after in the enchanted swamp.",
    "2. Return to their respective worlds, carrying the memories of their journey."
  ]
}
segment_1_5 = JSON.generate(segment_1_5)

segment_1_6 = {
  segment: 6,
  paragraphs: [
    "Choosing to forge a new path together, Gaga and Shrek decided to make the enchanted swamp their home. Embracing the vibrant and untamed surroundings, they built a life that celebrated their love and the bonds formed during their extraordinary journey.",
    "Gaga, once a princess confined by castle walls, now reveled in the freedom of the swamp. Shrek, the once-lonely ogre, found solace in the love that flourished between them. The donkey, their faithful companion, became a reminder of the laughter and camaraderie that defined their adventure.",
    "In this unconventional love story, the enchanted swamp served as the backdrop to their happily ever after. Gaga and Shrek's union bridged the gap between royalty and the untamed, proving that love could thrive in the most unexpected places. As their laughter echoed through the swamp, the once-isolated ogre and the adventurous princess discovered a love that truly knew no bounds."
  ]
}
segment_1_6 = JSON.generate(segment_1_6)

segment_2_1 = {
  segment: 1,
  title: "Shadows of Tomorrow",
  paragraphs: [
    "In the desolate wasteland of a post-apocalyptic world, where the sun struggled to pierce through thick clouds, a lone figure named Jack traversed the barren landscape. The air was heavy with an eerie silence, broken only by the distant howls of mutant creatures.",
    "As Jack trudged along, he stumbled upon a rusty, overturned vending machine half-buried in the ashy soil. Among the debris, he discovered a can of Mountain Dew, the last relic of the world that once was. Thirsty and desperate, he cracked it open, the fizz echoing in the desolation.",
    "Suddenly, a lazy junkyard dog emerged from the shadows, drawn by the sound. Its fur was a patchwork of grays, and its tail wagged cautiously. Jack, feeling a strange connection, shared a sip of the soda with his newfound companion.",
    "In the distance, a silhouette appeared – Mad-Dog McGee, a rugged man with a worn leather jacket and a gaze as sharp as the shards of the shattered world around them. He eyed Jack and the dog with a mix of curiosity and suspicion.",
    "Mad-Dog McGee spoke in gruff tones, revealing a hint of a plan to reach a rumored safe haven. Jack, the dog at his side, faced a crucial decision."
  ],
  choices: [
    "1. Trust Mad-Dog McGee and join forces for the perilous journey.",
    "2. Proceed alone, relying on instinct and avoiding potential danger."
  ]
}
segment_2_1 = JSON.generate(segment_2_1)

segment_2_2 = {
  segment: 2,
  paragraphs: [
    "With a nod of agreement, Jack decided to trust Mad-Dog McGee, recognizing the wisdom etched into the lines of his weathered face. Together, the trio set out on a treacherous path, navigating crumbling structures and dodging the mutated remnants of the past.",
    "As they journeyed, Mad-Dog shared tales of the world before, of cities bustling with life, now reduced to rubble. The lazy junkyard dog, who had become Jack's loyal companion, trotted alongside them, sniffing the air for potential dangers.",
    "Amidst the ruins, they stumbled upon an ancient gas station. Jack, drawn by a flickering neon sign, discovered a stash of supplies – canned goods, makeshift weapons, and another relic of the past, a tattered poster featuring a grinning Mad-Dog McGee holding a can of Mountain Dew.",
    "Their path forward split, presenting Jack with another choice."
  ],
  choices: [
    "1. Take a detour to explore the gas station further, hoping for additional supplies.",
    "2. Press on, wary of potential threats and prioritizing the safety of their journey."
  ]
}
segment_2_2 = JSON.generate(segment_2_2)

segment_2_3 = {
  segment: 3,
  paragraphs: [
    "Opting for caution, Jack, Mad-Dog McGee, and the junkyard dog pressed on through the desolate landscape. The air grew tense as they entered an abandoned city, the skeletal remains of towering buildings casting long shadows on the cracked pavement.",
    "As they advanced, a sudden noise echoed through the deserted streets. The lazy junkyard dog growled, its fur bristling with alertness. From the shadows emerged a group of scavengers, clad in tattered clothing and armed with makeshift weapons.",
    "Mad-Dog McGee, without hesitation, stepped forward, a glint of defiance in his eyes. A standoff ensued, and the scavengers demanded the trio's supplies. Jack faced a critical decision."
  ],
  choices: [
    "1. Negotiate with the scavengers, attempting to find a peaceful resolution.",
    "2. Trust Mad-Dog McGee's instincts and prepare for a confrontation, ready to defend their dwindling resources."
  ]
}
segment_2_3 = JSON.generate(segment_2_3)

segments = [
  {
    order: 0,
    message: system_prompt_1,
    role: "system",
    story_id: Story.last.id - 1
  },
  {
    order: 1,
    message: segment_1_1,
    role: "assistant",
    story_id: Story.last.id - 1
  },
  {
    order: 2,
    message: "1",
    role: "user",
    story_id: Story.last.id - 1
  },
  {
    order: 3,
    message: segment_1_2,
    role: "assistant",
    story_id: Story.last.id - 1
  },
  {
    order: 4,
    message: "2",
    role: "user",
    story_id: Story.last.id - 1
  },
  {
    order: 5,
    message: segment_1_3,
    role: "assistant",
    story_id: Story.last.id - 1
  },
  {
    order: 6,
    message: "1",
    role: "user",
    story_id: Story.last.id - 1
  },
  {
    order: 7,
    message: segment_1_4,
    role: "assistant",
    story_id: Story.last.id - 1
  },
  {
    order: 8,
    message: "1",
    role: "user",
    story_id: Story.last.id - 1
  },
  {
    order: 9,
    message: segment_1_5,
    role: "assistant",
    story_id: Story.last.id - 1
  },
  {
    order: 10,
    message: "1",
    role: "user",
    story_id: Story.last.id - 1
  },
  {
    order: 11,
    message: segment_1_6,
    role: "assistant",
    story_id: Story.last.id - 1
  },
  {
    order: 0,
    message: system_prompt_2,
    role: "system",
    story_id: Story.last.id
  },
  {
    order: 1,
    message: segment_2_1,
    role: "assistant",
    story_id: Story.last.id
  },
  {
    order: 2,
    message: "1",
    role: "user",
    story_id: Story.last.id
  },
  {
    order: 3,
    message: segment_2_2,
    role: "assistant",
    story_id: Story.last.id
  },
  {
    order: 4,
    message: "2",
    role: "user",
    story_id: Story.last.id
  },
  {
    order: 5,
    message: segment_2_3,
    role: "assistant",
    story_id: Story.last.id
  }
]

segments.each do |segment|
  StorySegment.create!(segment)
end

# OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO----------
# OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO----------
# OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO----------
# OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO----------
# ----------OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO
# ----------OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO
# ----------OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO
# ----------OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO----------OOOOOOOOOO
#                  F L A S H    C A R D    S E E D S

all_segments = StorySegment.where(role: "assistant")
all_users = User.all

50.times do
  begin
    segment = all_segments.sample
    serial = segment.message
    data = JSON.parse(serial)
    all_words = data["paragraphs"].join(" ").scan(/\b\w+\b/)
    word = all_words.sample
    file = URI.open("https://api.dictionaryapi.dev/api/v2/entries/en/#{word}").read
    document = JSON.parse(file)
    hash_string = "{ word: #{word}, parts_of_speech: ["
    sub_hash_strings_array = []
    part_of_speech_array = document[0]["meanings"]
    part_of_speech_array.each do |pos|
      sub_hash_string = "{"
      pos_term = pos["partOfSpeech"]
      sub_hash_string = "#{sub_hash_string} part_of_speech: \"#{pos_term}\", definitions: ["
      definitions = pos["definitions"]
      limited_array = []
      definitions.each_with_index do |row, index|
        break if index > 2
        limited_array << "\"#{row['definition']}\""
      end
      three_defs = limited_array.join(", ")
      sub_hash_string = "#{sub_hash_string}#{three_defs}]}"
      sub_hash_strings_array << sub_hash_string
    end
    hash_ending = sub_hash_strings_array.join(", ")
    hash_string = "#{hash_string}#{hash_ending}] }"
    card = Flashcard.new
    card.excerpt = word
    card.card_type = 1
    card.answer = hash_string
    card.study_status = rand(0..2)
    card.story_segment_id = segment.id
    card.user_id = all_users.sample.id
    card.save!
    puts "Made flashcard for #{word}"
  rescue OpenURI::HTTPError
    puts "Failed to make card for #{word}!"
    next
  end
end

puts "      You planted some pretty flowers!"
puts '                                      '
puts '        wWWWw               wWWWw    '
puts '  vVVVv (___) wWWWw         (___)  vVVVv  '
puts '  (___)  ~Y~  (___)  vVVVv   ~Y~   (___)  '
puts '   ~Y~   \|    ~Y~   (___)    |/    ~Y~   '
puts '   \|   \ |/   \| /  \~Y~/   \|    \ |/   '
puts '  \ |// \ |// \ |///\ \|//  \ |// \ \|/// '
puts '  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^   '
