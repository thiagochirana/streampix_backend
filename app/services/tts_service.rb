require "aws-sdk-polly"
require "aws-sdk"

class TtsService
  VOICES = [ "Ricardo", "Camila", "Vitoria", "Takumi" ].freeze

  def self.text_to_speak(message, voice)
    Aws::Credentials.new(ENV.fetch("AWS_ACCESS_KEY_ID"),
                         ENV.fetch("AWS_SECRET_ACCESS_KEY"),
                         ENV.fetch("AWS_REGION"))

    polly = Aws::Polly::Client.new

    resp = polly.synthesize_speech({
      output_format: "mp3",
      text: message,
      voice_id: voice
    })

    # mp3_file = donate_id + ".mp3"
    # IO.copy_stream(resp.audio_stream, Rails.root.join("tmp", "tts_donate", mp3_file))

    resp.audio_stream
  end
end
