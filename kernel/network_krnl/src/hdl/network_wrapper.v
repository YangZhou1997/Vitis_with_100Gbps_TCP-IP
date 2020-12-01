`timescale 1 ns / 1 ps

module network_wrapper #(
  parameter integer C_S_AXI_CONTROL_ADDR_WIDTH                = 12 ,
  parameter integer C_S_AXI_CONTROL_DATA_WIDTH                = 32 ,
  parameter integer C_M00_AXI_ADDR_WIDTH                      = 64 ,
  parameter integer C_M00_AXI_DATA_WIDTH                      = 512,
  parameter integer C_M01_AXI_ADDR_WIDTH                      = 64 ,
  parameter integer C_M01_AXI_DATA_WIDTH                      = 512,
  parameter integer C_M_AXIS_UDP_RX_TDATA_WIDTH               = 512,
  parameter integer C_S_AXIS_UDP_TX_TDATA_WIDTH               = 512,
  parameter integer C_M_AXIS_UDP_RX_META_TDATA_WIDTH          = 256,
  parameter integer C_S_AXIS_UDP_TX_META_TDATA_WIDTH          = 256,
  parameter integer C_S_AXIS_TCP_LISTEN_PORT_TDATA_WIDTH      = 16 ,
  parameter integer C_M_AXIS_TCP_PORT_STATUS_TDATA_WIDTH      = 8  ,
  parameter integer C_S_AXIS_TCP_OPEN_CONNECTION_TDATA_WIDTH  = 64 ,
  parameter integer C_M_AXIS_TCP_OPEN_STATUS_TDATA_WIDTH      = 32 ,
  parameter integer C_S_AXIS_TCP_CLOSE_CONNECTION_TDATA_WIDTH = 16 ,
  parameter integer C_M_AXIS_TCP_NOTIFICATION_TDATA_WIDTH     = 128,
  parameter integer C_S_AXIS_TCP_READ_PKG_TDATA_WIDTH         = 32 ,
  parameter integer C_M_AXIS_TCP_RX_META_TDATA_WIDTH          = 16 ,
  parameter integer C_M_AXIS_TCP_RX_DATA_TDATA_WIDTH          = 512,
  parameter integer C_S_AXIS_TCP_TX_META_TDATA_WIDTH          = 32 ,
  parameter integer C_S_AXIS_TCP_TX_DATA_TDATA_WIDTH          = 512,
  parameter integer C_M_AXIS_TCP_TX_STATUS_TDATA_WIDTH        = 64 ,
  parameter integer C_AXIS_NET_TX_TDATA_WIDTH                 = 512,
  parameter integer C_AXIS_NET_RX_TDATA_WIDTH                 = 512
)
(
  // System Signals
  input  wire                                                   ap_clk                            ,
  input  wire                                                   ap_rst_n                          ,
  // AXI4 master interface m00_axi
  output wire                                                   m00_axi_awvalid                   ,
  input  wire                                                   m00_axi_awready                   ,
  output wire [C_M00_AXI_ADDR_WIDTH-1:0]                        m00_axi_awaddr                    ,
  output wire [8-1:0]                                           m00_axi_awlen                     ,
  output wire                                                   m00_axi_wvalid                    ,
  input  wire                                                   m00_axi_wready                    ,
  output wire [C_M00_AXI_DATA_WIDTH-1:0]                        m00_axi_wdata                     ,
  output wire [C_M00_AXI_DATA_WIDTH/8-1:0]                      m00_axi_wstrb                     ,
  output wire                                                   m00_axi_wlast                     ,
  input  wire                                                   m00_axi_bvalid                    ,
  output wire                                                   m00_axi_bready                    ,
  output wire                                                   m00_axi_arvalid                   ,
  input  wire                                                   m00_axi_arready                   ,
  output wire [C_M00_AXI_ADDR_WIDTH-1:0]                        m00_axi_araddr                    ,
  output wire [8-1:0]                                           m00_axi_arlen                     ,
  input  wire                                                   m00_axi_rvalid                    ,
  output wire                                                   m00_axi_rready                    ,
  input  wire [C_M00_AXI_DATA_WIDTH-1:0]                        m00_axi_rdata                     ,
  input  wire                                                   m00_axi_rlast                     ,
  // AXI4 master interface m01_axi
  output wire                                                   m01_axi_awvalid                   ,
  input  wire                                                   m01_axi_awready                   ,
  output wire [C_M01_AXI_ADDR_WIDTH-1:0]                        m01_axi_awaddr                    ,
  output wire [8-1:0]                                           m01_axi_awlen                     ,
  output wire                                                   m01_axi_wvalid                    ,
  input  wire                                                   m01_axi_wready                    ,
  output wire [C_M01_AXI_DATA_WIDTH-1:0]                        m01_axi_wdata                     ,
  output wire [C_M01_AXI_DATA_WIDTH/8-1:0]                      m01_axi_wstrb                     ,
  output wire                                                   m01_axi_wlast                     ,
  input  wire                                                   m01_axi_bvalid                    ,
  output wire                                                   m01_axi_bready                    ,
  output wire                                                   m01_axi_arvalid                   ,
  input  wire                                                   m01_axi_arready                   ,
  output wire [C_M01_AXI_ADDR_WIDTH-1:0]                        m01_axi_araddr                    ,
  output wire [8-1:0]                                           m01_axi_arlen                     ,
  input  wire                                                   m01_axi_rvalid                    ,
  output wire                                                   m01_axi_rready                    ,
  input  wire [C_M01_AXI_DATA_WIDTH-1:0]                        m01_axi_rdata                     ,
  input  wire                                                   m01_axi_rlast                     ,
  // AXI4-Stream (master) interface m_axis_udp_rx
  output wire                                                   m_axis_udp_rx_tvalid              ,
  input  wire                                                   m_axis_udp_rx_tready              ,
  output wire [C_M_AXIS_UDP_RX_TDATA_WIDTH-1:0]                 m_axis_udp_rx_tdata               ,
  output wire [C_M_AXIS_UDP_RX_TDATA_WIDTH/8-1:0]               m_axis_udp_rx_tkeep               ,
  output wire                                                   m_axis_udp_rx_tlast               ,
  // AXI4-Stream (slave) interface s_axis_udp_tx
  input  wire                                                   s_axis_udp_tx_tvalid              ,
  output wire                                                   s_axis_udp_tx_tready              ,
  input  wire [C_S_AXIS_UDP_TX_TDATA_WIDTH-1:0]                 s_axis_udp_tx_tdata               ,
  input  wire [C_S_AXIS_UDP_TX_TDATA_WIDTH/8-1:0]               s_axis_udp_tx_tkeep               ,
  input  wire                                                   s_axis_udp_tx_tlast               ,
  // AXI4-Stream (master) interface m_axis_udp_rx_meta
  output wire                                                   m_axis_udp_rx_meta_tvalid         ,
  input  wire                                                   m_axis_udp_rx_meta_tready         ,
  output wire [C_M_AXIS_UDP_RX_META_TDATA_WIDTH-1:0]            m_axis_udp_rx_meta_tdata          ,
  output wire [C_M_AXIS_UDP_RX_META_TDATA_WIDTH/8-1:0]          m_axis_udp_rx_meta_tkeep          ,
  output wire                                                   m_axis_udp_rx_meta_tlast          ,
  // AXI4-Stream (slave) interface s_axis_udp_tx_meta
  input  wire                                                   s_axis_udp_tx_meta_tvalid         ,
  output wire                                                   s_axis_udp_tx_meta_tready         ,
  input  wire [C_S_AXIS_UDP_TX_META_TDATA_WIDTH-1:0]            s_axis_udp_tx_meta_tdata          ,
  input  wire [C_S_AXIS_UDP_TX_META_TDATA_WIDTH/8-1:0]          s_axis_udp_tx_meta_tkeep          ,
  input  wire                                                   s_axis_udp_tx_meta_tlast          ,
  // AXI4-Stream (slave) interface s_axis_tcp_listen_port
  input  wire                                                   s_axis_tcp_listen_port_tvalid     ,
  output wire                                                   s_axis_tcp_listen_port_tready     ,
  input  wire [C_S_AXIS_TCP_LISTEN_PORT_TDATA_WIDTH-1:0]        s_axis_tcp_listen_port_tdata      ,
  input  wire [C_S_AXIS_TCP_LISTEN_PORT_TDATA_WIDTH/8-1:0]      s_axis_tcp_listen_port_tkeep      ,
  input  wire                                                   s_axis_tcp_listen_port_tlast      ,
  // AXI4-Stream (master) interface m_axis_tcp_port_status
  output wire                                                   m_axis_tcp_port_status_tvalid     ,
  input  wire                                                   m_axis_tcp_port_status_tready     ,
  output wire [C_M_AXIS_TCP_PORT_STATUS_TDATA_WIDTH-1:0]        m_axis_tcp_port_status_tdata      ,
  output wire                                                   m_axis_tcp_port_status_tlast      ,
  // AXI4-Stream (slave) interface s_axis_tcp_open_connection
  input  wire                                                   s_axis_tcp_open_connection_tvalid ,
  output wire                                                   s_axis_tcp_open_connection_tready ,
  input  wire [C_S_AXIS_TCP_OPEN_CONNECTION_TDATA_WIDTH-1:0]    s_axis_tcp_open_connection_tdata  ,
  input  wire [C_S_AXIS_TCP_OPEN_CONNECTION_TDATA_WIDTH/8-1:0]  s_axis_tcp_open_connection_tkeep  ,
  input  wire                                                   s_axis_tcp_open_connection_tlast  ,
  // AXI4-Stream (master) interface m_axis_tcp_open_status
  output wire                                                   m_axis_tcp_open_status_tvalid     ,
  input  wire                                                   m_axis_tcp_open_status_tready     ,
  output wire [C_M_AXIS_TCP_OPEN_STATUS_TDATA_WIDTH-1:0]        m_axis_tcp_open_status_tdata      ,
  output wire [C_M_AXIS_TCP_OPEN_STATUS_TDATA_WIDTH/8-1:0]      m_axis_tcp_open_status_tkeep      ,
  output wire                                                   m_axis_tcp_open_status_tlast      ,
  // AXI4-Stream (slave) interface s_axis_tcp_close_connection
  input  wire                                                   s_axis_tcp_close_connection_tvalid,
  output wire                                                   s_axis_tcp_close_connection_tready,
  input  wire [C_S_AXIS_TCP_CLOSE_CONNECTION_TDATA_WIDTH-1:0]   s_axis_tcp_close_connection_tdata ,
  input  wire [C_S_AXIS_TCP_CLOSE_CONNECTION_TDATA_WIDTH/8-1:0] s_axis_tcp_close_connection_tkeep ,
  input  wire                                                   s_axis_tcp_close_connection_tlast ,
  // AXI4-Stream (master) interface m_axis_tcp_notification
  output wire                                                   m_axis_tcp_notification_tvalid    ,
  input  wire                                                   m_axis_tcp_notification_tready    ,
  output wire [C_M_AXIS_TCP_NOTIFICATION_TDATA_WIDTH-1:0]       m_axis_tcp_notification_tdata     ,
  output wire [C_M_AXIS_TCP_NOTIFICATION_TDATA_WIDTH/8-1:0]     m_axis_tcp_notification_tkeep     ,
  output wire                                                   m_axis_tcp_notification_tlast     ,
  // AXI4-Stream (slave) interface s_axis_tcp_read_pkg
  input  wire                                                   s_axis_tcp_read_pkg_tvalid        ,
  output wire                                                   s_axis_tcp_read_pkg_tready        ,
  input  wire [C_S_AXIS_TCP_READ_PKG_TDATA_WIDTH-1:0]           s_axis_tcp_read_pkg_tdata         ,
  input  wire [C_S_AXIS_TCP_READ_PKG_TDATA_WIDTH/8-1:0]         s_axis_tcp_read_pkg_tkeep         ,
  input  wire                                                   s_axis_tcp_read_pkg_tlast         ,
  // AXI4-Stream (master) interface m_axis_tcp_rx_meta
  output wire                                                   m_axis_tcp_rx_meta_tvalid         ,
  input  wire                                                   m_axis_tcp_rx_meta_tready         ,
  output wire [C_M_AXIS_TCP_RX_META_TDATA_WIDTH-1:0]            m_axis_tcp_rx_meta_tdata          ,
  output wire [C_M_AXIS_TCP_RX_META_TDATA_WIDTH/8-1:0]          m_axis_tcp_rx_meta_tkeep          ,
  output wire                                                   m_axis_tcp_rx_meta_tlast          ,
  // AXI4-Stream (master) interface m_axis_tcp_rx_data
  output wire                                                   m_axis_tcp_rx_data_tvalid         ,
  input  wire                                                   m_axis_tcp_rx_data_tready         ,
  output wire [C_M_AXIS_TCP_RX_DATA_TDATA_WIDTH-1:0]            m_axis_tcp_rx_data_tdata          ,
  output wire [C_M_AXIS_TCP_RX_DATA_TDATA_WIDTH/8-1:0]          m_axis_tcp_rx_data_tkeep          ,
  output wire                                                   m_axis_tcp_rx_data_tlast          ,
  // AXI4-Stream (slave) interface s_axis_tcp_tx_meta
  input  wire                                                   s_axis_tcp_tx_meta_tvalid         ,
  output wire                                                   s_axis_tcp_tx_meta_tready         ,
  input  wire [C_S_AXIS_TCP_TX_META_TDATA_WIDTH-1:0]            s_axis_tcp_tx_meta_tdata          ,
  input  wire [C_S_AXIS_TCP_TX_META_TDATA_WIDTH/8-1:0]          s_axis_tcp_tx_meta_tkeep          ,
  input  wire                                                   s_axis_tcp_tx_meta_tlast          ,
  // AXI4-Stream (slave) interface s_axis_tcp_tx_data
  input  wire                                                   s_axis_tcp_tx_data_tvalid         ,
  output wire                                                   s_axis_tcp_tx_data_tready         ,
  input  wire [C_S_AXIS_TCP_TX_DATA_TDATA_WIDTH-1:0]            s_axis_tcp_tx_data_tdata          ,
  input  wire [C_S_AXIS_TCP_TX_DATA_TDATA_WIDTH/8-1:0]          s_axis_tcp_tx_data_tkeep          ,
  input  wire                                                   s_axis_tcp_tx_data_tlast          ,
  // AXI4-Stream (master) interface m_axis_tcp_tx_status
  output wire                                                   m_axis_tcp_tx_status_tvalid       ,
  input  wire                                                   m_axis_tcp_tx_status_tready       ,
  output wire [C_M_AXIS_TCP_TX_STATUS_TDATA_WIDTH-1:0]          m_axis_tcp_tx_status_tdata        ,
  output wire [C_M_AXIS_TCP_TX_STATUS_TDATA_WIDTH/8-1:0]        m_axis_tcp_tx_status_tkeep        ,
  output wire                                                   m_axis_tcp_tx_status_tlast        ,
  // AXI4-Stream (master) interface axis_net_tx
  output wire                                                   axis_net_tx_tvalid                ,
  input  wire                                                   axis_net_tx_tready                ,
  output wire [C_AXIS_NET_TX_TDATA_WIDTH-1:0]                   axis_net_tx_tdata                 ,
  output wire [C_AXIS_NET_TX_TDATA_WIDTH/8-1:0]                 axis_net_tx_tkeep                 ,
  output wire                                                   axis_net_tx_tlast                 ,
  // AXI4-Stream (slave) interface axis_net_rx
  input  wire                                                   axis_net_rx_tvalid                ,
  output wire                                                   axis_net_rx_tready                ,
  input  wire [C_AXIS_NET_RX_TDATA_WIDTH-1:0]                   axis_net_rx_tdata                 ,
  input  wire [C_AXIS_NET_RX_TDATA_WIDTH/8-1:0]                 axis_net_rx_tkeep                 ,
  input  wire                                                   axis_net_rx_tlast                 ,
  // AXI4-Lite slave interface
  input  wire                                                   s_axi_control_awvalid             ,
  output wire                                                   s_axi_control_awready             ,
  input  wire [C_S_AXI_CONTROL_ADDR_WIDTH-1:0]                  s_axi_control_awaddr              ,
  input  wire                                                   s_axi_control_wvalid              ,
  output wire                                                   s_axi_control_wready              ,
  input  wire [C_S_AXI_CONTROL_DATA_WIDTH-1:0]                  s_axi_control_wdata               ,
  input  wire [C_S_AXI_CONTROL_DATA_WIDTH/8-1:0]                s_axi_control_wstrb               ,
  input  wire                                                   s_axi_control_arvalid             ,
  output wire                                                   s_axi_control_arready             ,
  input  wire [C_S_AXI_CONTROL_ADDR_WIDTH-1:0]                  s_axi_control_araddr              ,
  output wire                                                   s_axi_control_rvalid              ,
  input  wire                                                   s_axi_control_rready              ,
  output wire [C_S_AXI_CONTROL_DATA_WIDTH-1:0]                  s_axi_control_rdata               ,
  output wire [2-1:0]                                           s_axi_control_rresp               ,
  output wire                                                   s_axi_control_bvalid              ,
  input  wire                                                   s_axi_control_bready              ,
  output wire [2-1:0]                                           s_axi_control_bresp               ,
  output wire                                                   interrupt                         
);

  network_krnl #(
    .C_S_AXI_CONTROL_ADDR_WIDTH(C_S_AXI_CONTROL_ADDR_WIDTH),
    .C_S_AXI_CONTROL_DATA_WIDTH(C_S_AXI_CONTROL_DATA_WIDTH),
    .C_M00_AXI_ADDR_WIDTH(C_M00_AXI_ADDR_WIDTH),
    .C_M00_AXI_DATA_WIDTH(C_M00_AXI_DATA_WIDTH),
    .C_M01_AXI_ADDR_WIDTH(C_M01_AXI_ADDR_WIDTH),
    .C_M01_AXI_DATA_WIDTH(C_M01_AXI_DATA_WIDTH),
    .C_M_AXIS_UDP_RX_TDATA_WIDTH(C_M_AXIS_UDP_RX_TDATA_WIDTH),
    .C_S_AXIS_UDP_TX_TDATA_WIDTH(C_S_AXIS_UDP_TX_TDATA_WIDTH),
    .C_M_AXIS_UDP_RX_META_TDATA_WIDTH(C_M_AXIS_UDP_RX_META_TDATA_WIDTH),
    .C_S_AXIS_UDP_TX_META_TDATA_WIDTH(C_S_AXIS_UDP_TX_META_TDATA_WIDTH),
    .C_S_AXIS_TCP_LISTEN_PORT_TDATA_WIDTH(C_S_AXIS_TCP_LISTEN_PORT_TDATA_WIDTH),
    .C_M_AXIS_TCP_PORT_STATUS_TDATA_WIDTH(C_M_AXIS_TCP_PORT_STATUS_TDATA_WIDTH),
    .C_S_AXIS_TCP_OPEN_CONNECTION_TDATA_WIDTH(C_S_AXIS_TCP_OPEN_CONNECTION_TDATA_WIDTH),
    .C_M_AXIS_TCP_OPEN_STATUS_TDATA_WIDTH(C_M_AXIS_TCP_OPEN_STATUS_TDATA_WIDTH),
    .C_S_AXIS_TCP_CLOSE_CONNECTION_TDATA_WIDTH(C_S_AXIS_TCP_CLOSE_CONNECTION_TDATA_WIDTH),
    .C_M_AXIS_TCP_NOTIFICATION_TDATA_WIDTH(C_M_AXIS_TCP_NOTIFICATION_TDATA_WIDTH),
    .C_S_AXIS_TCP_READ_PKG_TDATA_WIDTH(C_S_AXIS_TCP_READ_PKG_TDATA_WIDTH),
    .C_M_AXIS_TCP_RX_META_TDATA_WIDTH(C_M_AXIS_TCP_RX_META_TDATA_WIDTH),
    .C_M_AXIS_TCP_RX_DATA_TDATA_WIDTH(C_M_AXIS_TCP_RX_DATA_TDATA_WIDTH),
    .C_S_AXIS_TCP_TX_META_TDATA_WIDTH(C_S_AXIS_TCP_TX_META_TDATA_WIDTH),
    .C_S_AXIS_TCP_TX_DATA_TDATA_WIDTH(C_S_AXIS_TCP_TX_DATA_TDATA_WIDTH),
    .C_M_AXIS_TCP_TX_STATUS_TDATA_WIDTH(C_M_AXIS_TCP_TX_STATUS_TDATA_WIDTH),
    .C_AXIS_NET_TX_TDATA_WIDTH(C_AXIS_NET_TX_TDATA_WIDTH),
    .C_AXIS_NET_RX_TDATA_WIDTH(C_AXIS_NET_RX_TDATA_WIDTH)
  )
  (
.ap_clk                            (ap_clk                            ),
.ap_rst_n                          (ap_rst_n                          ),
.m00_axi_awvalid                   (m00_axi_awvalid                   ),
.m00_axi_awready                   (m00_axi_awready                   ),
.m00_axi_awaddr                    (m00_axi_awaddr                    ),
.m00_axi_awlen                     (m00_axi_awlen                     ),
.m00_axi_wvalid                    (m00_axi_wvalid                    ),
.m00_axi_wready                    (m00_axi_wready                    ),
.m00_axi_wdata                     (m00_axi_wdata                     ),
.m00_axi_wstrb                     (m00_axi_wstrb                     ),
.m00_axi_wlast                     (m00_axi_wlast                     ),
.m00_axi_bvalid                    (m00_axi_bvalid                    ),
.m00_axi_bready                    (m00_axi_bready                    ),
.m00_axi_arvalid                   (m00_axi_arvalid                   ),
.m00_axi_arready                   (m00_axi_arready                   ),
.m00_axi_araddr                    (m00_axi_araddr                    ),
.m00_axi_arlen                     (m00_axi_arlen                     ),
.m00_axi_rvalid                    (m00_axi_rvalid                    ),
.m00_axi_rready                    (m00_axi_rready                    ),
.m00_axi_rdata                     (m00_axi_rdata                     ),
.m00_axi_rlast                     (m00_axi_rlast                     ),
.m01_axi_awvalid                   (m01_axi_awvalid                   ),
.m01_axi_awready                   (m01_axi_awready                   ),
.m01_axi_awaddr                    (m01_axi_awaddr                    ),
.m01_axi_awlen                     (m01_axi_awlen                     ),
.m01_axi_wvalid                    (m01_axi_wvalid                    ),
.m01_axi_wready                    (m01_axi_wready                    ),
.m01_axi_wdata                     (m01_axi_wdata                     ),
.m01_axi_wstrb                     (m01_axi_wstrb                     ),
.m01_axi_wlast                     (m01_axi_wlast                     ),
.m01_axi_bvalid                    (m01_axi_bvalid                    ),
.m01_axi_bready                    (m01_axi_bready                    ),
.m01_axi_arvalid                   (m01_axi_arvalid                   ),
.m01_axi_arready                   (m01_axi_arready                   ),
.m01_axi_araddr                    (m01_axi_araddr                    ),
.m01_axi_arlen                     (m01_axi_arlen                     ),
.m01_axi_rvalid                    (m01_axi_rvalid                    ),
.m01_axi_rready                    (m01_axi_rready                    ),
.m01_axi_rdata                     (m01_axi_rdata                     ),
.m01_axi_rlast                     (m01_axi_rlast                     ),
.m_axis_udp_rx_tvalid              (m_axis_udp_rx_tvalid              ),
.m_axis_udp_rx_tready              (m_axis_udp_rx_tready              ),
.m_axis_udp_rx_tdata               (m_axis_udp_rx_tdata               ),
.m_axis_udp_rx_tkeep               (m_axis_udp_rx_tkeep               ),
.m_axis_udp_rx_tlast               (m_axis_udp_rx_tlast               ),
.s_axis_udp_tx_tvalid              (s_axis_udp_tx_tvalid              ),
.s_axis_udp_tx_tready              (s_axis_udp_tx_tready              ),
.s_axis_udp_tx_tdata               (s_axis_udp_tx_tdata               ),
.s_axis_udp_tx_tkeep               (s_axis_udp_tx_tkeep               ),
.s_axis_udp_tx_tlast               (s_axis_udp_tx_tlast               ),
.m_axis_udp_rx_meta_tvalid         (m_axis_udp_rx_meta_tvalid         ),
.m_axis_udp_rx_meta_tready         (m_axis_udp_rx_meta_tready         ),
.m_axis_udp_rx_meta_tdata          (m_axis_udp_rx_meta_tdata          ),
.m_axis_udp_rx_meta_tkeep          (m_axis_udp_rx_meta_tkeep          ),
.m_axis_udp_rx_meta_tlast          (m_axis_udp_rx_meta_tlast          ),
.s_axis_udp_tx_meta_tvalid         (s_axis_udp_tx_meta_tvalid         ),
.s_axis_udp_tx_meta_tready         (s_axis_udp_tx_meta_tready         ),
.s_axis_udp_tx_meta_tdata          (s_axis_udp_tx_meta_tdata          ),
.s_axis_udp_tx_meta_tkeep          (s_axis_udp_tx_meta_tkeep          ),
.s_axis_udp_tx_meta_tlast          (s_axis_udp_tx_meta_tlast          ),
.s_axis_tcp_listen_port_tvalid     (s_axis_tcp_listen_port_tvalid     ),
.s_axis_tcp_listen_port_tready     (s_axis_tcp_listen_port_tready     ),
.s_axis_tcp_listen_port_tdata      (s_axis_tcp_listen_port_tdata      ),
.s_axis_tcp_listen_port_tkeep      (s_axis_tcp_listen_port_tkeep      ),
.s_axis_tcp_listen_port_tlast      (s_axis_tcp_listen_port_tlast      ),
.m_axis_tcp_port_status_tvalid     (m_axis_tcp_port_status_tvalid     ),
.m_axis_tcp_port_status_tready     (m_axis_tcp_port_status_tready     ),
.m_axis_tcp_port_status_tdata      (m_axis_tcp_port_status_tdata      ),
.m_axis_tcp_port_status_tlast      (m_axis_tcp_port_status_tlast      ),
.s_axis_tcp_open_connection_tvalid (s_axis_tcp_open_connection_tvalid ),
.s_axis_tcp_open_connection_tready (s_axis_tcp_open_connection_tready ),
.s_axis_tcp_open_connection_tdata  (s_axis_tcp_open_connection_tdata  ),
.s_axis_tcp_open_connection_tkeep  (s_axis_tcp_open_connection_tkeep  ),
.s_axis_tcp_open_connection_tlast  (s_axis_tcp_open_connection_tlast  ),
.m_axis_tcp_open_status_tvalid     (m_axis_tcp_open_status_tvalid     ),
.m_axis_tcp_open_status_tready     (m_axis_tcp_open_status_tready     ),
.m_axis_tcp_open_status_tdata      (m_axis_tcp_open_status_tdata      ),
.m_axis_tcp_open_status_tkeep      (m_axis_tcp_open_status_tkeep      ),
.m_axis_tcp_open_status_tlast      (m_axis_tcp_open_status_tlast      ),
.s_axis_tcp_close_connection_tvalid(s_axis_tcp_close_connection_tvalid),
.s_axis_tcp_close_connection_tready(s_axis_tcp_close_connection_tready),
.s_axis_tcp_close_connection_tdata (s_axis_tcp_close_connection_tdata ),
.s_axis_tcp_close_connection_tkeep (s_axis_tcp_close_connection_tkeep ),
.s_axis_tcp_close_connection_tlast (s_axis_tcp_close_connection_tlast ),
.m_axis_tcp_notification_tvalid    (m_axis_tcp_notification_tvalid    ),
.m_axis_tcp_notification_tready    (m_axis_tcp_notification_tready    ),
.m_axis_tcp_notification_tdata     (m_axis_tcp_notification_tdata     ),
.m_axis_tcp_notification_tkeep     (m_axis_tcp_notification_tkeep     ),
.m_axis_tcp_notification_tlast     (m_axis_tcp_notification_tlast     ),
.s_axis_tcp_read_pkg_tvalid        (s_axis_tcp_read_pkg_tvalid        ),
.s_axis_tcp_read_pkg_tready        (s_axis_tcp_read_pkg_tready        ),
.s_axis_tcp_read_pkg_tdata         (s_axis_tcp_read_pkg_tdata         ),
.s_axis_tcp_read_pkg_tkeep         (s_axis_tcp_read_pkg_tkeep         ),
.s_axis_tcp_read_pkg_tlast         (s_axis_tcp_read_pkg_tlast         ),
.m_axis_tcp_rx_meta_tvalid         (m_axis_tcp_rx_meta_tvalid         ),
.m_axis_tcp_rx_meta_tready         (m_axis_tcp_rx_meta_tready         ),
.m_axis_tcp_rx_meta_tdata          (m_axis_tcp_rx_meta_tdata          ),
.m_axis_tcp_rx_meta_tkeep          (m_axis_tcp_rx_meta_tkeep          ),
.m_axis_tcp_rx_meta_tlast          (m_axis_tcp_rx_meta_tlast          ),
.m_axis_tcp_rx_data_tvalid         (m_axis_tcp_rx_data_tvalid         ),
.m_axis_tcp_rx_data_tready         (m_axis_tcp_rx_data_tready         ),
.m_axis_tcp_rx_data_tdata          (m_axis_tcp_rx_data_tdata          ),
.m_axis_tcp_rx_data_tkeep          (m_axis_tcp_rx_data_tkeep          ),
.m_axis_tcp_rx_data_tlast          (m_axis_tcp_rx_data_tlast          ),
.s_axis_tcp_tx_meta_tvalid         (s_axis_tcp_tx_meta_tvalid         ),
.s_axis_tcp_tx_meta_tready         (s_axis_tcp_tx_meta_tready         ),
.s_axis_tcp_tx_meta_tdata          (s_axis_tcp_tx_meta_tdata          ),
.s_axis_tcp_tx_meta_tkeep          (s_axis_tcp_tx_meta_tkeep          ),
.s_axis_tcp_tx_meta_tlast          (s_axis_tcp_tx_meta_tlast          ),
.s_axis_tcp_tx_data_tvalid         (s_axis_tcp_tx_data_tvalid         ),
.s_axis_tcp_tx_data_tready         (s_axis_tcp_tx_data_tready         ),
.s_axis_tcp_tx_data_tdata          (s_axis_tcp_tx_data_tdata          ),
.s_axis_tcp_tx_data_tkeep          (s_axis_tcp_tx_data_tkeep          ),
.s_axis_tcp_tx_data_tlast          (s_axis_tcp_tx_data_tlast          ),
.m_axis_tcp_tx_status_tvalid       (m_axis_tcp_tx_status_tvalid       ),
.m_axis_tcp_tx_status_tready       (m_axis_tcp_tx_status_tready       ),
.m_axis_tcp_tx_status_tdata        (m_axis_tcp_tx_status_tdata        ),
.m_axis_tcp_tx_status_tkeep        (m_axis_tcp_tx_status_tkeep        ),
.m_axis_tcp_tx_status_tlast        (m_axis_tcp_tx_status_tlast        ),
.axis_net_tx_tvalid                (axis_net_tx_tvalid                ),
.axis_net_tx_tready                (axis_net_tx_tready                ),
.axis_net_tx_tdata                 (axis_net_tx_tdata                 ),
.axis_net_tx_tkeep                 (axis_net_tx_tkeep                 ),
.axis_net_tx_tlast                 (axis_net_tx_tlast                 ),
.axis_net_rx_tvalid                (axis_net_rx_tvalid                ),
.axis_net_rx_tready                (axis_net_rx_tready                ),
.axis_net_rx_tdata                 (axis_net_rx_tdata                 ),
.axis_net_rx_tkeep                 (axis_net_rx_tkeep                 ),
.axis_net_rx_tlast                 (axis_net_rx_tlast                 ),
.s_axi_control_awvalid             (s_axi_control_awvalid             ),
.s_axi_control_awready             (s_axi_control_awready             ),
.s_axi_control_awaddr              (s_axi_control_awaddr              ),
.s_axi_control_wvalid              (s_axi_control_wvalid              ),
.s_axi_control_wready              (s_axi_control_wready              ),
.s_axi_control_wdata               (s_axi_control_wdata               ),
.s_axi_control_wstrb               (s_axi_control_wstrb               ),
.s_axi_control_arvalid             (s_axi_control_arvalid             ),
.s_axi_control_arready             (s_axi_control_arready             ),
.s_axi_control_araddr              (s_axi_control_araddr              ),
.s_axi_control_rvalid              (s_axi_control_rvalid              ),
.s_axi_control_rready              (s_axi_control_rready              ),
.s_axi_control_rdata               (s_axi_control_rdata               ),
.s_axi_control_rresp               (s_axi_control_rresp               ),
.s_axi_control_bvalid              (s_axi_control_bvalid              ),
.s_axi_control_bready              (s_axi_control_bready              ),
.s_axi_control_bresp               (s_axi_control_bresp               ),
.interrupt                         (interrupt                         )
  );

endmodule