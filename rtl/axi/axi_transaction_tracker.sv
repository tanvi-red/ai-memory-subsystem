// rtl/axi/axi_transaction_tracker.sv
module axi_transaction_tracker #(
    parameter int ADDR_WIDTH = 40,
    parameter int DATA_WIDTH = 128,
    parameter int ID_WIDTH   = 4
)(
    axi_if.slave bus
);

    // ---------------------------------------------------------
    // AXI Protocol Assertions (Immediate & Concurrent Checks)
    // ---------------------------------------------------------

    // Property: AWVALID must remain high until AWREADY is asserted
    property p_aw_stability;
        @(posedge bus.clk) disable iff (!bus.rst_n)
            (bus.awvalid && !bus.awready) |-> ##1 (bus.awvalid);
    endproperty
    assert property (p_aw_stability) 
        else $error("[AXI Protocol Error] AWVALID dropped before AWREADY handshake!");

    // Property: ARVALID must remain high until ARREADY is asserted
    property p_ar_stability;
        @(posedge bus.clk) disable iff (!bus.rst_n)
            (bus.arvalid && !bus.arready) |-> ##1 (bus.arvalid);
    endproperty
    assert property (p_ar_stability) 
        else $error("[AXI Protocol Error] ARVALID dropped before ARREADY handshake!");

    // Property: WVALID must remain high until WREADY is asserted
    property p_w_stability;
        @(posedge bus.clk) disable iff (!bus.rst_n)
            (bus.wvalid && !bus.wready) |-> ##1 (bus.wvalid);
    endproperty
    assert property (p_w_stability) 
        else $error("[AXI Protocol Error] WVALID dropped before WREADY handshake!");

    // ---------------------------------------------------------
    // Transaction Logging & Tracking Counter
    // ---------------------------------------------------------
    int unsigned write_tx_count = 0;
    int unsigned read_tx_count  = 0;

    always_ff @(posedge bus.clk or negedge bus.rst_n) begin
        if (!bus.rst_n) begin
            write_tx_count <= 0;
            read_tx_count  <= 0;
        end else begin
            // Count completed write address handshakes
            if (bus.awvalid && bus.awready) begin
                write_tx_count <= write_tx_count + 1;
                $display("[%0t] [AXI Tracker] Write Transaction Started: ID=%0h, ADDR=%0h", 
                         $time, bus.awid, bus.awaddr);
            end

            // Count completed read address handshakes
            if (bus.arvalid && bus.arready) begin
                read_tx_count <= read_tx_count + 1;
                $display("[%0t] [AXI Tracker] Read Transaction Started: ID=%0h, ADDR=%0h", 
                         $time, bus.arid, bus.araddr);
            end
        end
    end

endmodule