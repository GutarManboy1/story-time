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
  # def testcall
  #   response = client.chat(
  #     parameters: {
  #       model: "gpt-3.5-turbo",
  #       messages: [
  #         {
  #           role: "user",
  #           content: "Hello, my name is JD, and I'm 41 years old.",
  #         },
  #         {
  #           role: "assistant",
  #           content: "Nice to meet you."
  #         },
  #         {
  #           role: "user",
  #           content: "I have a son named Sean as well, who is 4."
  #         },
  #         {
  #           role: "assistant",
  #           content: "I understand. You have a son named Sean who is 4 years old."
  #         },
  #         {
  #           role: "user",
  #           content: prompt
  #         }
  #       ],
  #       temperature: 0.7,
  #       stream: false,
  #       max_tokens: 200  <---im unsure about the limits of this.
  #     }
  #   )
  #   return response["choices"][0]["message"]["content"]
  # end
  # ----------THIS CODE WORKS-----------
  # the above code successfully answered a simple question to the following prompt in the console using the line below....
  # OpenaiService.new("Okay, this is a test.  What do you remember about me so far?").testcall
  # The api returned "You are JD, 41 years old, and you have a son named Sean who is 4 years old."
  # which proves that structuring queries in this way allows GPT to reference information from earlier in the "chat".
end
