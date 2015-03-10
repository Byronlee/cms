class AddKryptonPassportInvitationSentAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :krypton_passport_invitation_sent_at, :datetime
  end
end
