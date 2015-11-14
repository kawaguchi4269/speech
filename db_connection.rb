# Testで使うこともあるので
def App.dbm
  DatabaseManagement.new
end

def App.db
  SQLite3::Database.new('speech.db')
end
