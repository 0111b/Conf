local notify = {
    name: 'notify',
    image: 'appleboy/drone-telegram',
    settings: {
        token: { from_secret: 'telegram_token' },
        to: { from_secret: 'telegram_chat' }
    }
};

local swift(name, commands) = {
    name: name,
    image: 'swift:5.2.3',
    commands: commands,
};

local build(configuration='debug') = swift(
    'build_%(configuration)s' % { configuration: configuration },
    [
        'swift package clean',
        'swift build -c %(configuration)s --enable-test-discovery' % { configuration: configuration },
    ]
);

local test = swift('test', [
    'swift test --enable-test-discovery',
]);

local codecov = swift('codecov', [
    'swift package clean',
    'swift test --enable-test-discovery --enable-code-coverage',
    'BINARY_PATH=$(find .build/debug/ -maxdepth 1 -name "*.xctest" | head -1)',
    'PROF_DATA_PATH=.build/debug/codecov/default.profdata',
    'IGNORE_FILENAME_REGEX="(.build|TestUtils|Tests)"',
    'llvm-cov report "$BINARY_PATH" --format=text -instr-profile="$PROF_DATA_PATH" -ignore-filename-regex="$IGNORE_FILENAME_REGEX"',
]);


local lint = {
    name: 'lint',
    image: 'norionomura/swiftlint:0.39.2',
    commands: [
        'scripts/lint.sh',
    ],
};


local whenCommitToNonMaster(step) = step {
  when: {
    event: ['push'],
    branch: { exclude: ['master'] },
  }
};

local commitToNonMasterSteps = std.map(whenCommitToNonMaster, [
  build('debug'),
  test,
]);

local whenUpdatePR(step) = step {
    when: {
        event: ['pull_request']
    },
};

local whenUpdatePRSteps = std.map(whenUpdatePR, [
    codecov,
    notify
]);


local whenMergeToMaster(step) = step {
  when: {
    event: ['push'],
    branch: ['master'],
  },
};

local mergeToMasterSteps = std.map(whenMergeToMaster, [
    build('release'),
]);

local pipelines = std.flattenArrays([
    [lint],
    commitToNonMasterSteps,
    whenUpdatePRSteps,
    mergeToMasterSteps,
]);

{
    name: 'default',
    kind: 'pipeline',
    steps: pipelines
}