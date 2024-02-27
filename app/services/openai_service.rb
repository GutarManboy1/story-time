require "openai"

class OpenaiService
  attr_reader :client, :prompt

  def initialize(prompt)
    @client = OpenAI::Client.new
    @prompt = prompt
  end

  # this method is the simple version for making a GPT api call....
  def call
    response = client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [{ role: "user", content: prompt }],
        temperature: 0.7,
        stream: false,
        max_tokens: 100
      }
    )
    return response["choices"][0]["message"]["content"]
  end


  # and this method shows the structure of how you would input a "chat" as a prompt for the GPT api
  def testcall
    response = client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [
          {
            role: "system",
            content: "You are a live storyteller for a \"choose your own adventure\" style STORY.
                      Your job is to chat with the user, telling parts (a.k.a. SEGEMENTS) of a STORY  one at a time, and then presenting the USER with 2 CHOICES to choose from to progress the story.
                      Limit yourself to one story segment and one choice per chat message.
                      Limit the vocabulary used in the story to the B1 level of CEFR.
                      A SEGMENT contains a SEGMENT-NUMBER, between 4 and 6 PARAGRAPHS, and 2 CHOICES.
                      A PARAGRAPH contains between 3 and 5 complete SENTENCES.
                      A CHOICE should be an explicitly described action that the protagonist could take, given the immediate context.
                      A CHOICE should not describe or infer any results or consequences that would result if the USER chooses that CHOICE.
                      Choices should include a number (either 1. or 2.) at the start.
                      The USER will indicate their CHOICE by typing either \"1\" or \"2\" in chat.
                      The NARRATOR should write the next SEGMENT based on the USER's CHOICE.
                      A STORY should contain a minimum of 5 SEGMENTS, but each chat MESSAGE only contains 1 of those SEGMENTS.
                      After the USER has made 5 CHOICES in chat, each subsequent USER CHOICE has a 35% CHANCE to generate the STORY ENDING SEGMENT.
                      An ENDING SEGMENT can be either GOOD or BAD.
                      A GOOD ENDING should resolve by the protagonist accomplishing their goal.
                      A BAD ENDING should resolve by the protagonist suddenly dying, being killed, or experiencing tragedy.
                      Each SEGMENT must be formatted as embedded JSON.
                      The JSON should look like this: { segment: $segment_number, paragraphs: [$paragraph1, $paragraph2, $paragraph3, (etc...)],  choices: [$choice1, $choice2], (etc...) }
                      The JSON for the first SEGMENT  should also have a \"title: $title\" key-value pair inserted after the \"segment:\" key-value pair.
                      The ENDING SEGMENT JSON does not need the \"choices:\" key-value pair.
                      The NARRATOR must not write anything outside of the JSON.
                      The genre of the STORY will be a fairy tale.
                      In addition to the overall structure above, incorporate the following words/phrases (separated by commas) as THEMES, ELEMENTS or CHARACTERS within the story as appropriate:
                      a girl named Abigail, a fire, a singing field mouse
                      The THEMES, ELEMENTS and CHARACTERS do not need to be introduced all at once, but should be included by the end of the 5th story segment.
                      Try to introduce each THEME, ELEMENT or CHARACTER at a time that makes sense in the overall narrative.
                      You should be very flexible and creative with the title, and make it relate to the  THEMES, ELEMENTS and CHARACTERS presented earlier.  The title can be up to 10 words long.",
          },
          {
            role: "assistant",
            content: "{
              \"segment\": 1,
              \"title\": \"Abigail and the Tiny Singer\",
              \"paragraphs\": [
                \"In a quaint village nestled between rolling hills and lush forests, there lived a young girl named Abigail. She was known for her adventurous spirit and kind heart, always eager to explore the mysteries of the world around her.\",
                \"One day, while wandering through the woods, Abigail stumbled upon a hidden glen bathed in golden sunlight. In the center of the glen stood an ancient oak tree, its branches reaching towards the sky like outstretched arms. Curiosity piqued, Abigail approached the tree, drawn by an otherworldly glow emanating from its gnarled trunk.\",
                \"As she drew closer, Abigail discovered a small fire flickering at the base of the oak tree. Entranced by the dancing flames, she felt a sense of warmth and wonder wash over her. Suddenly, a tiny voice broke the silence, causing Abigail to startle and look around.\",
                \"To her amazement, a tiny field mouse with fur as soft as silk emerged from a nearby bush. The mouse looked up at Abigail with bright, beady eyes and began to sing a sweet melody, its voice filling the glen with enchanting music.\"
                ],
              \"choices\": [
                \"1. Approach the singing field mouse cautiously.\",
                \"2. Back away slowly, unsure of the mouse's intentions.\"
                ]
              }"
          },
          {
            role: "user",
            content: "1"
          },
          {
            role: "assistant",
            content: "{
              \"segment\": 2,
              \"paragraphs\": [
              \"Abigail, captivated by the singing field mouse, decided to approach cautiously, taking slow and deliberate steps. The mouse paused its melody, studying her with curiosity as she drew nearer.\",
              \"As Abigail reached out her hand, the field mouse hopped onto her palm, continuing its sweet serenade. The mouse introduced itself as Melody, a magical creature of the woods. It shared tales of an enchanted realm hidden within the heart of the forest and spoke of a grand quest awaiting a brave soul.\",
              \"With a gleam in her eyes, Abigail listened intently. Melody explained that to embark on this journey, Abigail needed to follow the mysterious path illuminated by the fire at the oak tree's base. The fire, Melody said, was a guide to the realm of wonders and challenges that awaited her.\",
              \"Filled with determination, Abigail thanked Melody for the guidance and prepared herself for the unknown journey ahead. She took a deep breath, embraced the warmth of the fire, and set forth on the glowing path into the heart of the enchanted forest.\"
              ],
              \"choices\": [
              \"1. Venture deeper into the enchanted forest.\",
              \"2. Hesitate and reconsider the journey, unsure of the risks.\"
              ]
              }"
          },
          {
            role: "user",
            content: "1"
          },
          {
            role: "assistant",
            content: "{
              \"segment\": 3,
              \"paragraphs\": [
              \"Abigail courageously ventured deeper into the enchanted forest, following the mesmerizing glow that led her through thickets and ancient trees. The air shimmered with magic, and the sounds of unseen creatures filled the surroundings.\",
              \"As she continued, the path twisted and turned, revealing mystical creatures that watched her with both curiosity and caution. Yet, Abigail pressed on, guided by the radiant trail of the fire. The forest seemed to come alive, responding to her determination with a symphony of whispers and rustling leaves.\",
              \"After a while, the path led Abigail to a clearing where a magnificent waterfall cascaded down from a rocky ledge. At the center of the clearing, a majestic phoenix with vibrant plumage stood, its fiery wings extended in a regal display. The phoenix spoke in a melodic voice, offering Abigail a choice that would shape her destiny.\",
              \"It revealed that to unlock the next stage of her journey, Abigail must either embrace the flames and display her inner courage or choose a more cautious route, avoiding the intense heat of the phoenix's fiery wings.\"
              ],
              \"choices\": [
              \"1. Embrace the flames and display inner courage.\",
              \"2. Choose a cautious route, avoiding the intense heat.\"
              ]
              }"
          },
          {
            role: "user",
            content: "2"
          },
          {
            role: "assistant",
            content: "{
            \"segment\": 4,
            \"paragraphs\": [
            \"Abigail, sensing the intensity of the phoenix's fiery wings, chose a cautious route. She carefully maneuvered around the majestic bird, avoiding the scorching heat and opting for a path that led her through a serene grove of ancient trees.\",
            \"The grove, bathed in dappled sunlight, felt peaceful and safe. Abigail marveled at the beauty of the ancient trees, their gnarled branches forming natural archways overhead. The singing of birds and the gentle rustling of leaves created a tranquil melody as she continued her journey.\",
            \"However, as Abigail delved deeper into the grove, the path became increasingly tangled, and the once-clear trail began to fade. Uncertainty crept into her heart as she realized that she might have deviated from the main route. Lost in the grove, Abigail had to make another decision to find her way back.\",
            \"Suddenly, she heard the distant melody of Melody, the singing field mouse, echoing through the trees. The sound seemed to be coming from two different directions, and Abigail now faced a choice to follow the melody to the left or the right.\"
            ],
            \"choices\": [
            \"1. Follow the melody to the left.\",
            \"2. Follow the melody to the right.\"
            ]
            }"
          },
          {
            role: "user",
            content: "2"
          },
          {
            role: "assistant",
            content: "{
            \"segment\": 5,
            \"paragraphs\": [
            \"Choosing to follow the melody to the right, Abigail weaved through the ancient trees in the grove. The soft singing of Melody, the field mouse, grew louder, guiding her through the labyrinth of foliage. As she walked, the air filled with a calming energy, easing her worries.\",
            \"After a short while, Abigail emerged from the grove into a breathtaking meadow bathed in the soft light of the setting sun. The melody ceased, and there, at the center of the meadow, stood a magnificent unicorn with a coat as white as freshly fallen snow.\",
            \"The unicorn, named Harmony, greeted Abigail with a gentle nuzzle. It spoke of the final leg of her journey and presented two paths: one leading to a mystical waterfall that held the key to her deepest desires and the other to a dark cave filled with unknown challenges.\",
            \"Abigail, standing at this pivotal moment, must make a choice that will determine the outcome of her quest.\"
            ],
            \"choices\": [
            \"1. Head towards the mystical waterfall.\",
            \"2. Brave the challenges within the dark cave.\"
            ]
            }"
          },
          {
            role: "user",
            content: "2"
          },
          {
            role: "assistant",
            content: "{
              \"segment\": 6,
              \"paragraphs\": [
              \"Choosing to brave the challenges within the dark cave, Abigail felt a surge of determination. She bid farewell to Harmony, the unicorn, and entered the foreboding darkness of the cavern. The narrow passage twisted and turned, leading her deeper into the unknown.\",
              \"As Abigail ventured forth, the cave revealed hidden wonders—glowing crystals that illuminated the rocky walls and mysterious symbols etched into the stone floor. The air hummed with an ancient magic that seemed to guide her steps. However, the deeper she went, the more ominous the atmosphere became.\",
              \"Suddenly, the cave opened into a vast chamber where an ancient, wise dragon awaited. The dragon spoke of the trials Abigail had faced and praised her courage. It then presented her with a glowing orb, the embodiment of her deepest desires. Abigail's heart swelled with gratitude as the dragon offered her a way back home, triumphant in her quest.\",
              \"With her goal achieved, Abigail now had the choice to either return home with the glowing orb or explore the enchanted realm further, unlocking its untold mysteries.\"
              ],
              \"choices\": [
              \"1. Return home with the glowing orb.\",
              \"2. Explore the enchanted realm further, unlocking mysteries.\"
              ]
              }"
          },
          {
            role: "user",
            content: "1"
          },
          {
            role: "assistant",
            content: "{
            \"segment\": 7,
            \"paragraphs\": [
            \"Abigail chose to return home with the glowing orb, cradling her deepest desires in her hands. As she emerged from the dark cave, the enchanted forest seemed to celebrate her victory. Glowing fireflies illuminated her path, and the trees whispered words of congratulations.\",
            \"With each step, the surroundings transformed, and Abigail found herself back at the village, the quaint houses warmly welcoming her return. The villagers gathered, astonished by the radiant glow emanating from the orb in her hands. Abigail's courage and determination had not only fulfilled her own desires but had also brought a newfound enchantment to her entire village.\",
            \"From that day forward, Abigail's tale became a beloved legend, inspiring generations to come. The singing field mouse, Melody, continued to share her story through sweet melodies, ensuring that the magic of her enchanted journey would endure for eternity.\"
            ]
            }"
          },
          {
            role: "user",
            content: prompt
          }
        ],
        temperature: 0.7,
        stream: false,
        max_tokens: 4096
      }
    )
    return response["choices"][0]["message"]["content"]
  end
  # ----------THIS CODE WORKS-----------
  # the above code successfully answered a simple question to the following prompt in the console using the line below....
  # OpenaiService.new("Okay, this is a test.  What do you remember about me so far?").testcall
  # The api returned "You are JD, 41 years old, and you have a son named Sean who is 4 years old."
  # which proves that structuring queries in this way allows GPT to reference information from earlier in the "chat".
end
