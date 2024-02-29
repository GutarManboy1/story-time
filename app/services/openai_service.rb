require "openai"
require "json"

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
        response_format: {
          type: "json_object"
        },
        messages: [{ role: "system", content: prompt }],
        temperature: 0.8,
        stream: false,
        max_tokens: 4000
      }
    )
    return response["choices"][0]["message"]["content"]
  end

  def add_segment_call
    p prompt.class
    p prompt
    response = client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        response_format: {
          type: "json_object"
        },
        messages: prompt,
        temperature: 0.8,
        stream: false,
        max_tokens: 4000
      }
    )
    return response["choices"][0]["message"]["content"]
  end


  # and this method shows the structure of how you would input a "chat" as a prompt for the GPT api
  # "story settings is a hash consisting of level:string length:int genre:string and themes:string"
  def testcall
    params = {
      model: "gpt-3.5-turbo",
      messages: [
        {
        role: "system",
        content: <<~SYSTEM_PROMPT
                  You are a live storyteller for a "choose your own adventure" style STORY.
                  Your job is to chat with the user, telling parts (a.k.a. SEGEMENTS) of a STORY  one at a time, and then presenting the USER with 2 CHOICES to choose from to progress the story.
                  Limit yourself to one story segment and one choice per chat message.
                  Limit the vocabulary used in the story to the #{story_settings[:level]} level of CEFR.
                  A SEGMENT contains a SEGMENT-NUMBER, between #{story_settings[:length]} and #{story_settings[:length] + 2} PARAGRAPHS, and 2 CHOICES.
                  A PARAGRAPH is a long text, containing between #{story_settings[:length] - 1} and #{story_settings[:length] + 1} complete SENTENCES.
                  A CHOICE should be an explicitly described action that the protagonist could take, given the immediate context.
                  A CHOICE should not describe or infer any results or consequences that would result if the USER chooses that CHOICE.
                  Choices should include a number (either 1. or 2.) at the start.
                  The USER will indicate their CHOICE by typing either "1" or "2" in chat.
                  The NARRATOR should write the next SEGMENT based on the USER's CHOICE.
                  A STORY should contain a minimum of #{story_settings[:length] + 1} SEGMENTS, but each chat MESSAGE only contains 1 of those SEGMENTS.
                  After the USER has made #{story_settings[:length] + 1} CHOICES in chat, each subsequent USER CHOICE has a 35% CHANCE to generate the STORY ENDING SEGMENT.
                  An ENDING SEGMENT can be either GOOD or BAD.
                  A GOOD ENDING should resolve by the protagonist accomplishing their goal.
                  A BAD ENDING should resolve by the protagonist suddenly dying, being killed, or experiencing tragedy.
                  Each SEGMENT must be formatted as embedded JSON.
                  The JSON should look like this: { segment: $segment_number, paragraphs: [$paragraph1, $paragraph2, $paragraph3, (etc...)],  choices: [$choice1, $choice2]}
                  The JSON for the first SEGMENT  should also have a "title: $title" key-value pair inserted after the "segment:" key-value pair.
                  The ENDING SEGMENT JSON does not need the "choices:" key-value pair.
                  The NARRATOR must not write anything outside of the JSON.
                  The genre of the STORY will be #{story_settings[:genre]}.
                  In addition to the overall structure above, incorporate the following words/phrases (separated by commas) as THEMES, ELEMENTS or CHARACTERS within the story as appropriate:
                  #{story_settings[:themes]}
                  The THEMES, ELEMENTS and CHARACTERS do not need to be introduced all at once, but should be included by the end of the #{story_settings[:length] + 1}th story segment.
                  Try to introduce each THEME, ELEMENT or CHARACTER at a time that makes sense in the overall narrative.
                  You should be very flexible and creative with the title, and make it relate to the  THEMES, ELEMENTS and CHARACTERS presented earlier.  The title can be up to 10 words long.
                  Before sending your response back, check that the following criteria are met, and then fix your response to meet the criteria as needed:
                    1. :segment is present and correct.
                    2. if :segment is 1, :title is present.
                    3. there are between #{story_settings[:length]} and #{story_settings[:length] + 2} elements in the :paragraphs array.
                    4. each index of the :paragraphs array is a string made up of #{story_settings[:length] - 1} and #{story_settings[:length] + 1} complete sentences.
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
        },
        {
          role: "assistant",
          content: <<~ASSISTANT
            {
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
          ASSISTANT
        },
        {
          role: 'user',
          content: "1"
        }
      ],
      temperature: 0.7,
      stream: false,
      max_tokens: 4096
    }
    response = client.chat(parameters: params)

    p params[:messages][0][:content]
    return "#{response["choices"][0]["message"]["content"]} \n\n The prompt was... \n\n#{params[:messages][0][:content]}"
  end
  # ----------THIS CODE WORKS-----------
  # the above code successfully answered a simple question to the following prompt in the console using the line below....
  # OpenaiService.new("Okay, this is a test.  What do you remember about me so far?").testcall
  # The api returned "You are JD, 41 years old, and you have a son named Sean who is 4 years old."
  # which proves that structuring queries in this way allows GPT to reference information from earlier in the "chat".
end
