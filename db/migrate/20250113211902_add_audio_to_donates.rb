class AddAudioToDonates < ActiveRecord::Migration[8.0]
  def change
    add_column :donates, :audio_donate, :binary
    add_column :donates, :voice_sellected, :string
  end
end
