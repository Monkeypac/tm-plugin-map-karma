bool isDevMode = Meta::IsDeveloperMode();

void log_trace(const string&in input) {
    if (isDevMode) trace(input);
}

void log_info(const string&in input) {
    print(input);
}

void log_warn(const string&in input) {
    warn(input);
}

void log_error(const string&in input) {
    error(input);
}
