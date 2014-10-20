class AccessLogStatusStatsJob
 MIN_STATUS = 400
  PRESTO_HOST = "127.0.0.1:8080"
  PRESTO_CATALOG = "hive"
  PRESTO_SCHEMA = "default"
  PRESTO_USER = "presto"
  PRESTO_DEBUG = false

  @queue = :presto

  def self.perform(seconds)
    client = Presto::Client.new(
      server: PRESTO_HOST,
      catalog: PRESTO_CATALOG,
      schema: PRESTO_SCHEMA,
      user: PRESTO_USER,
      http_debug: PRESTO_DEBUG
    )
    old_created_at = Time.now
    client.query("select count(status), host, cast(status as bigint), request from accesslog_fin2 where cast(status as bigint) >= #{MIN_STATUS.to_i} group by host, status, request order by host") do |q|
      q.each_row {|row|
        AccessLogStatusStat.create(count: row[0], host: row[1], status: row[2], request: row[3])
      }
    end
    AccessLogStatusStat.where('created_at <= ?', old_created_at).destroy_all
  end
end
