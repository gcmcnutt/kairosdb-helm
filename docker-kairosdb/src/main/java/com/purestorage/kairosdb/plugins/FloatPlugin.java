package com.purestorage.kairosdb.plugins;

import com.google.inject.AbstractModule;
import com.google.inject.Singleton;
import com.purestorage.kairosdb.datapoints.FloatDataPointFactory;

public class FloatPlugin extends AbstractModule {
    @Override
    protected void configure() {
        bind(FloatDataPointFactory.class).in(Singleton.class);
    }
}
