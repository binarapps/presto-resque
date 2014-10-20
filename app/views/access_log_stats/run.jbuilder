if @status == :ok
  json.msg 'Access log analysis started!'
else
  json.msg 'Error occured! Please try later.'
end
