package com.purestorage.kairosdb.plugins;

import com.google.inject.AbstractModule;
import com.google.inject.Singleton;
import com.purestorage.kairosdb.datapoints.CombinedDataPointFactory;

public class CombinedPlugin extends AbstractModule {
    @Override
    protected void configure() {
        bind(CombinedDataPointFactory.class).in(Singleton.class);
    }
}
