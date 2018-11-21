package com.purestorage.kairosdb.datapoints;


import org.json.JSONException;
import org.json.JSONWriter;
import org.kairosdb.core.datapoints.DataPointHelper;

import java.io.DataOutput;
import java.io.IOException;

public class CombinedDataPoint extends DataPointHelper {
    private static final String API_TYPE = "combined";
    private float br;
    private float bw;
    private float ir;
    private float iw;
    private float lr;
    private float lw;

    public CombinedDataPoint(long timestamp, float br, float bw, float ir, float iw, float lr, float lw) {
        super(timestamp);
        this.br = br;
        this.bw = bw;
        this.ir = ir;
        this.iw = iw;
        this.lr = lr;
        this.lw = lw;
    }

    @Override
    public void writeValueToBuffer(DataOutput buffer) throws IOException {
        buffer.writeFloat(br);
        buffer.writeFloat(bw);
        buffer.writeFloat(ir);
        buffer.writeFloat(iw);
        buffer.writeFloat(lr);
        buffer.writeFloat(lw);
    }

    @Override
    public void writeValueToJson(JSONWriter writer) throws JSONException {
        writer.value(br);
        writer.value(bw);
        writer.value(ir);
        writer.value(iw);
        writer.value(lr);
        writer.value(lw);
    }

    @Override
    public String getApiDataType() {
        return API_TYPE;
    }

    @Override
    public String getDataStoreDataType() {
        return CombinedDataPointFactory.DST_COMBINED;
    }

    @Override
    public boolean isLong() {
        return false;
    }

    @Override
    public long getLongValue() {
        return 0;
    }

    @Override
    public boolean isDouble() {
        return false;
    }

    @Override
    public double getDoubleValue() {
        return 0;
    }

    public float getBr() {
        return br;
    }

    public float getBw() {
        return bw;
    }

    public float getIr() {
        return ir;
    }

    public float getIw() {
        return iw;
    }

    public float getLr() {
        return lr;
    }

    public float getLw() {
        return lw;
    }
}
