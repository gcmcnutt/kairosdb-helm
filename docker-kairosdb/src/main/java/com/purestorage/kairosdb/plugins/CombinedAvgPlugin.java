package com.purestorage.kairosdb.plugins;

import com.google.inject.AbstractModule;
import com.google.inject.Singleton;
import com.purestorage.kairosdb.aggregators.CombinedAvgAggregator;

public class CombinedAvgPlugin extends AbstractModule {
    @Override
    protected void configure() {
        bind(CombinedAvgAggregator.class).in(Singleton.class);
    }
}
