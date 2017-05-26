module Message
  module MessageClassMethods
    def self.included(klass) 
      klass.extend ClassMethods
    end

    module ClassMethods
      def received_messages_for_admin
        Message.where(archived: false).joins(:user).where(users: { admin: false })
      end

      def received_messages_for_user
        Message.where(archived_by_user: false).joins(:user).where(users: { admin: true })
      end



      def sent_messages_for_admin
        Message.where(draft: false, archived: false).joins(:user).where(users: { admin: true })
      end

      def sent_messages_for_user
        Message.where(draft: false, archived_by_user: false).joins(:user).where(users: { admin: false })  
      end



      def drafted_by_admin
        Message.where(draft: true, archived: false).joins(:user).where(users: { admin: true })
      end

      def drafted_by_user
        Message.where(draft: true, archived_by_user: false).joins(:user).where(users: { admin: false })
      end



      def messages_archived_by_admin
        @messages = []
        Message.where(archived: true).joins(:user).where(users: { admin: true }).each do |message|
          @messages << message
        end
        Message.where(archived: true).joins(:user).where(users: { admin: false }).each do |message|
          @messages << message
        end
        @messages
      end

      def messages_archived_by_user
        @messages = []
        Message.where(archived_by_user: true).joins(:user).where(users: { admin: true }).each do |message|
          @messages << message
      end
        Message.where(archived_by_user: true).joins(:user).where(users: { admin: false }).each do |message|
          @messages << message
        end
        @messages
      end
    end
  end
end