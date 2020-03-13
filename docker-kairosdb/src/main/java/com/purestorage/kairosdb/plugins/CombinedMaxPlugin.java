package com.purestorage.kairosdb.plugins;

import com.google.inject.AbstractModule;
import com.google.inject.Singleton;
import com.purestorage.kairosdb.aggregators.CombinedMaxAggregator;

public class CombinedMaxPlugin extends AbstractModule {
    @Override
    protected void configure() {
        bind(CombinedMaxAggregator.class).in(Singleton.class);
    }
}
