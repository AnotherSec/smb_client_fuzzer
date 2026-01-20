class MetasploitModule < Msf::Auxiliary
  include Msf::Exploit::Remote::TcpServer

  Rank = ManualRanking

  def initialize(info = {})
    super(update_info(info,
      'Name'           => 'SMB Client Protocol Fuzzer v2.0',
      'Description'    => %q{
          SMB Client Fuzzer - Multi-stage SMB1/2/3 fuzzing.        
      },
      'Author'         => [ 'AnotherSecurity / pwdnx1337' ],
      'License'        => MSF_LICENSE
    ))
  end

  def on_client_data(client)
    return if @clients[client][:fuzzed]
    
    data = client.get_once(-1, 10) 
    return unless data && data.length > 4
    
    info = @clients[client]
    
    case info[:state]
    when :negotiate
      handle_smb_negotiate(client, data, info)
      info[:state] = :session_setup unless info[:fuzzed]
    when :session_setup
      handle_session_setup(client, data, info)
      info[:state] = :tree_connect unless info[:fuzzed]
    when :tree_connect
      handle_tree_connect(client, data, info)
    end
  end

  
  def handle_smb_negotiate(client, data, info)
    if data[4,1] == "\xFF"  # SMB1 magic
      info[:smb_version] = 'SMB1'
      info[:state] = :session_setup
      send_smb1_negotiate_response(client, info)
    elsif data[4,4] == "\xFE\x53\x4D\x42"  # SMB2/3 magic
      info[:smb_version] = 'SMB2/3'
      info[:state] = :session_setup
      send_smb2_negotiate_response(client, info)
    else
      print_error("Unknown SMB magic: #{data[0,8].unpack('H*')}")
    end
  end

end
