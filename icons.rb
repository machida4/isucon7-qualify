require 'mysql2'

def db
  db_client = Mysql2::Client.new(
    host: ENV.fetch('ISUBATA_DB_HOST') { 'localhost' },
    port: ENV.fetch('ISUBATA_DB_PORT') { '3306' },
    username: ENV.fetch('ISUBATA_DB_USER') { 'root' },
    password: ENV.fetch('ISUBATA_DB_PASSWORD') { '' },
    database: 'isubata',
    encoding: 'utf8mb4'
  )
  db_client.query('SET SESSION sql_mode=\'TRADITIONAL,NO_AUTO_VALUE_ON_ZERO,ONLY_FULL_GROUP_BY\'')
  db_client
end

# get '/icons/:file_name' do
#   file_name = params[:file_name]
#   statement = db.prepare('SELECT * FROM image WHERE name = ?')
#   row = statement.execute(file_name).first
#   statement.close
#   ext = file_name.include?('.') ? File.extname(file_name) : ''
#   mime = ext2mime(ext)
#   if !row.nil? && !mime.empty?
#     content_type mime
#     return row['data']
#   end
#   404
# end

rows = db.query('SELECT * FROM image')
rows.each do |row|
  File.open("/home/isucon/isubata/webapp/public/icons/#{row["name"]}", "w") { |f| f.write(row["data"]) }
end
