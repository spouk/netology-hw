[serversnat]

%{~ for stock in [sdisk,sc,sfe] ~}
    %{~ for x in stock  ~}
        ${x["name"]}   ansible_host=${x["network_interface"][0]["nat_ip_address"]}
    %{~ endfor ~}
%{~ endfor ~}

