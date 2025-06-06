
// State management
const state = {
    biomarkerName: "",
    backendEnablerActive: false,

    consistencyScore: 0,
    reproducibilityScore: 0,
    specificityScore: 0,

    tc: 0,
    tr: 0,
    ts: 0,

    improvementGeneralHealth: 0,
    riskReductionChronicDisease: 0,
    supportLivingWithChronicDisease: 0,

    t1: 0,
    t2: 0,
    t3: 0,

    validPublicationCount: 0,
    validStatementCount: 0,
    currentImpactFactor: 0,
    currentPublicationsCount: 0,

    currentOrganisationName: "",
    currentStatementCount: 0
};

    // Flow chart steps
const steps = [
{
    id: 0,
    type: "inputQuestion",
    question: "Enter biomarker name",
    inputType: "text",
    update: (input) => {
    state.biomarkerName = input;
},
    next: 1
},
{
    id: 1,
    type: "inputQuestion",
    question: "Enter consistency value",
    inputType: "number",
    update: (input) => {
    state.consistencyScore = parseFloat(input);
},
        next: 2
},
{
    id: 2,
    type: "inputQuestion",
    question: "Enter reproducibility value",
    inputType: "number",
    update: (input) => {
    state.reproducibilityScore = parseFloat(input);
},
    next: 3
},
{
id: 3,
    type: "inputQuestion",
    question: "Enter specificity value",
    inputType: "number",
    update: (input) => {
    state.specificityScore = parseFloat(input);
},
    next: 4
},
{
    id: 4,
    type: "functionDecision",
    test: () => {
    return state.specificityScore > state.ts &&
    state.reproducibilityScore > state.tr &&
    state.consistencyScore > state.tc;
},
    yes: 6,
    no: 5
},
{
id: 5,
type: "question",
question: "Not a good biomarker",
    next: null,
    decision: false,
    end: true
},
{
    id: 6,
    type: "multipleChoice",
    question: "Taking into account the biomarker's hypothesis development and the intended use or purpose of the test, how would you like to classify this biomarker?",
    options: [
{ text: "General wellness", next: 8 },
{ text: "Clinical", next: 7 }
    ]
},
{
id: 7,
    type: "question",
    question: "Detected clinical use: this case is out of scope for the algorithm",
    next: null,
    decision: false,
    end: true
},
{
    id: 8,
    type: "functionDecision",
    test: () => state.backendEnablerActive,
    yes: 12,
    no: 9
},
{
id: 9,
type: "multipleChoice",
    question: "Does the biomarker represent improvement of general health?",
    options: [
{ text: "Yes", next: 16 },
{ text: "No", next: 10 }
    ]
},
{
    id: 10,
    type: "multipleChoice",
    question: "Does the biomarker help reduce the risk of chronic diseases or conditions?",
    options: [
{ text: "Yes", next: 16 },
{ text: "No", next: 11 }
    ]
},
{
    id: 11,
    type: "multipleChoice",
    question: "Does the biomarker help support living well with certain chronic diseases or conditions?",
    options: [
{ text: "Yes", next: 16 },
{ text: "No", next: 12 }
    ]
},
{
id: 12,
type: "inputQuestion",
question: "Enter value for improvement of general state of health",
    inputType: "number",
    update: (input) => {
    state.improvementGeneralHealth = parseFloat(input);
},
    next: 13
},
{
    id: 13,
    type: "inputQuestion",
    question: "Enter value for help in reducing the risk of chronic diseases or condition",
    inputType: "number",
    update: (input) => {
    state.riskReductionChronicDisease = parseFloat(input);
},
    next: 14
},
{
id: 14,
type: "inputQuestion",
    question: "Enter value for help in living well with certain chronic diseases or condition",
    inputType: "number",
    update: (input) => {
    state.supportLivingWithChronicDisease = parseFloat(input);
},
    next: 15
},
{
    id: 15,
    type: "functionDecision",
    test: () => {
    return state.improvementGeneralHealth > state.t1 ||
    state.riskReductionChronicDisease > state.t2 ||
    state.supportLivingWithChronicDisease > state.t3;
},
    yes: 16,
    no: 12
},
{
    id: 16,
    type: "question",
    question: "Health outcomes generally accepted.",
    next: 17,
    decision: false
},
{
    id: 17,
    type: "multipleChoice",
    question: "Are there peer-reviewed scientific publications?",
    options: [
{ text: "Yes", next: 18 },
{ text: "No", next: 22 }
    ]
},
{
    id: 18,
    type: "inputQuestion",
    question: "Enter the journal impact factor",
    inputType: "number",
    update: (input) => {
    state.currentImpactFactor = parseFloat(input);
},
    next: 19
},
{
    id: 19,
    type: "inputQuestion",
    question: "Enter the number of publications for this journal",
    inputType: "number",
    update: (input) => {
    state.currentPublicationsCount = parseInt(input);
},
    next: 20
},
{
    id: 20,
    type: "functionDecision",
    test: () => state.currentImpactFactor > 4,
    yes: 21,
    no: 17
},
{
    id: 21,
    type: "function",
    execute: () => {
    state.validPublicationCount += state.currentPublicationsCount;
    state.currentPublicationsCount = 0;
},
    next: 17
},
{
    id: 22,
    type: "multipleChoice",
    question: "Are there Official statements made by healthcare organizations?",
    options: [
{ text: "Yes", next: 23 },
{ text: "No", next: 27 }
    ]
},
{
    id: 23,
    type: "inputQuestion",
    question: "Enter the name of the organization",
    inputType: "text",
    update: (input) => {
    state.currentOrganisationName = input;
},
    next: 24
},
{
    id: 24,
    type: "inputQuestion",
    question: "Enter the number statement",
    inputType: "number",
    update: (input) => {
    state.currentStatementCount = parseInt(input);
},
    next: 25
},
{
    id: 25,
    type: "functionDecision",
    test: () => {
    return ["FDA", "WDH"].includes(state.currentOrganisationName);
},
    yes: 26,
    no: 22
},
{
    id: 26,
    type: "function",
    execute: () => {
    state.validStatementCount += state.currentStatementCount;
    state.currentStatementCount = 0;
},
    next: 22
},
{
    id: 27,
    type: "functionDecision",
    test: () => {
    return state.validPublicationCount + state.validStatementCount > 3;
},
    yes: 29,
    no: 28
},
{
    id: 28,
    type: "question",
    question: "Unproven significance",
    next: null,
    decision: false,
    end: true
},
{
    id: 29,
    type: "question",
    question: "High scientific significance",
    next: null,
    decision: false,
    end: true
}
];

// Global variables
let currentStepId = 0;
let isComplete = false;
let textInput = "";
let resultMessage = "";

// DOM Elements
const welcomeScreen = document.getElementById('welcome-screen');
const flowChartContainer = document.getElementById('flow-chart-container');
const stepCard = document.getElementById('step-card');
const stepIndicator = document.getElementById('step-indicator');
const settingsIcon = document.getElementById('settings-icon');
const settingsPopover = document.getElementById('settings-popover');
const popoverBackdrop = document.querySelector('.popover-backdrop');
const startButton = document.getElementById('start-classification');
const restartButton = document.getElementById('restart-button');

// Initialize application
function init() {
    initSettingsListeners();

    startButton.addEventListener('click', () => {
    welcomeScreen.style.display = 'none';
    flowChartContainer.style.display = 'block';
    resetFlow();
    renderStepIndicator();
    renderCurrentStep();
});

    restartButton.addEventListener('click', () => {
    resetFlow();
    renderStepIndicator();
    renderCurrentStep();
});

    settingsIcon.addEventListener('click', () => {
    settingsPopover.style.display = 'block';
});

    popoverBackdrop.addEventListener('click', () => {
    settingsPopover.style.display = 'none';
});
}

    // Initialize settings sliders
function initSettingsListeners() {
// Threshold sliders
    setupSlider('tc', 'tc-slider', 'tc-value');
    setupSlider('tr', 'tr-slider', 'tr-value');
    setupSlider('ts', 'ts-slider', 'ts-value');
    setupSlider('t1', 't1-slider', 't1-value');
    setupSlider('t2', 't2-slider', 't2-value');
    setupSlider('t3', 't3-slider', 't3-value');

// Backend enabler toggle
    const backendEnabler = document.getElementById('backend-enabler');
    backendEnabler.addEventListener('change', (e) => {
    state.backendEnablerActive = e.target.checked;
});
}

    // Set up a slider with its input and display elements
function setupSlider(stateKey, sliderId, valueId) {
    const slider = document.getElementById(sliderId);
    const valueDisplay = document.getElementById(valueId);

    slider.addEventListener('input', (e) => {
    const value = parseFloat(e.target.value);
    state[stateKey] = value;
    valueDisplay.textContent = value.toFixed(1);
    updateStatusDisplay();
});
}

    // Reset the flow state
function resetFlow() {
    currentStepId = 0;
    isComplete = false;
    textInput = "";
    resultMessage = "";

    // Reset state values but keep thresholds
    state.biomarkerName = "";
    state.consistencyScore = 0;
    state.reproducibilityScore = 0;
    state.specificityScore = 0;
    state.improvementGeneralHealth = 0;
    state.riskReductionChronicDisease = 0;
    state.supportLivingWithChronicDisease = 0;
    state.validPublicationCount = 0;
    state.validStatementCount = 0;
    state.currentImpactFactor = 0;
    state.currentPublicationsCount = 0;
    state.currentOrganisationName = "";
    state.currentStatementCount = 0;

    updateStatusDisplay();
}

    // Render the step indicator
function renderStepIndicator() {
    stepIndicator.innerHTML = "";

    // Create dots for all steps
    for (let i = 0; i < steps.length; i++) {
    const dot = document.createElement('div');
    dot.className = `step-dot ${i === currentStepId ? 'current' : i < currentStepId ? 'completed' : 'pending'}`;
    dot.textContent = i;
    stepIndicator.appendChild(dot);
}
}

    // Find the current step
function getCurrentStep() {
    return steps.find(step => step.id === currentStepId);
}

    // Update the status display
function updateStatusDisplay() {
    // Update status values
    document.getElementById('status-biomarker').textContent = state.biomarkerName || '-';
    document.getElementById('status-consistency').textContent = state.consistencyScore.toFixed(1);
    document.getElementById('status-reproducibility').textContent = state.reproducibilityScore.toFixed(1);
    document.getElementById('status-specificity').textContent = state.specificityScore.toFixed(1);

    document.getElementById('status-tc').textContent = state.tc.toFixed(1);
    document.getElementById('status-tr').textContent = state.tr.toFixed(1);
    document.getElementById('status-ts').textContent = state.ts.toFixed(1);

    // Update valid counts display
    if (state.validPublicationCount > 0 || state.validStatementCount > 0) {
    document.getElementById('valid-counts').style.display = 'block';
    document.getElementById('status-valid-publications').textContent = state.validPublicationCount;
    document.getElementById('status-valid-statements').textContent = state.validStatementCount;
} else {
    document.getElementById('valid-counts').style.display = 'none';
}

    // Update debug info
    document.getElementById('debug-step-id').textContent = currentStepId;
    document.getElementById('debug-biomarker').textContent = state.biomarkerName || '-';
    document.getElementById('debug-consistency').textContent = state.consistencyScore;
    document.getElementById('debug-reproducibility').textContent = state.reproducibilityScore;
    document.getElementById('debug-specificity').textContent = state.specificityScore;
}

    // Process the current step and move to the next
function processStep(step) {
    if (!step) return;

switch (step.type) {
    case 'function':
    step.execute();
    if (step.next !== null) {
    currentStepId = step.next;
    renderStepIndicator();
    renderCurrentStep();
} else if (step.end) {
    completeFlow();
}
    break;

    case 'functionDecision':
    const result = step.test();
    if (step.end) {
    completeFlow();
} else {
    currentStepId = result ? step.yes : step.no;
    renderStepIndicator();
    renderCurrentStep();
}
    break;

    default:
    // Other cases are handled by user interaction
    break;
}
}

    // Complete the flow
function completeFlow() {
    isComplete = true;

    // Set result message based on step
    switch (currentStepId) {
    case 5:
    resultMessage = "Result: Not a good biomarker";
    break;
    case 7:
    resultMessage = "Result: Clinical use case detected - out of scope";
    break;
    case 28:
    resultMessage = "Result: Unproven significance";
    break;
    case 29:
    resultMessage = "Result: High scientific significance";
    break;
    default:
    resultMessage = "Flow completed at step " + currentStepId;
}

    renderCurrentStep();
}

    // Render the current step
function renderCurrentStep() {
    updateStatusDisplay();

    if (isComplete) {
    stepCard.innerHTML = `
                    <div class="result-message">${resultMessage}</div>
                `;
    return;
}

    const step = getCurrentStep();
    if (!step) {
    stepCard.innerHTML = `<p>No step found with ID: ${currentStepId}</p>`;
    return;
}

    switch (step.type) {
    case 'question':
    renderQuestionStep(step);
    break;
    case 'inputQuestion':
    renderInputQuestionStep(step);
    break;
    case 'multipleChoice':
    renderMultipleChoiceStep(step);
    break;
    case 'function':
    case 'functionDecision':
    stepCard.innerHTML = `<p>Processing...</p>`;
    setTimeout(() => processStep(step), 500);
    break;
}
}

    // Render a question step
    function renderQuestionStep(step) {
    stepCard.innerHTML = `
                <h3>${step.question}</h3>
                <div class="buttons-container">
                    ${step.decision ?
        `<button id="yes-button">Yes</button>
                         <button id="no-button" class="secondary">No</button>` :
        `<button id="continue-button">Continue</button>`
    }
                </div>
            `;

    if (step.decision) {
    document.getElementById('yes-button').addEventListener('click', () => {
    if (step.yes !== null) {
    currentStepId = step.yes;
    renderStepIndicator();
    renderCurrentStep();
} else if (step.end) {
    completeFlow();
}
});

    document.getElementById('no-button').addEventListener('click', () => {
    if (step.no !== null) {
    currentStepId = step.no;
    renderStepIndicator();
    renderCurrentStep();
} else if (step.end) {
    completeFlow();
}
});
} else {
    document.getElementById('continue-button').addEventListener('click', () => {
    if (step.next !== null) {
    currentStepId = step.next;
    renderStepIndicator();
    renderCurrentStep();
} else if (step.end) {
    completeFlow();
}
});
}
}

    // Render an input question step
function renderInputQuestionStep(step) {
    const inputType = step.inputType.toLowerCase() === 'text' ? 'text' : 'number';
    const placeholder = inputType === 'text' ? 'Enter text' : 'Enter number';

    stepCard.innerHTML = `
                <h3>${step.question}</h3>
                <input type="${inputType}" id="step-input" placeholder="${placeholder}" />
                <div class="buttons-container">
                    <button id="submit-button" disabled>Submit</button>
                </div>
            `;

    const input = document.getElementById('step-input');
    const submitButton = document.getElementById('submit-button');

    input.addEventListener('input', () => {
    submitButton.disabled = input.value.trim() === '';
});

    submitButton.addEventListener('click', () => {
    step.update(input.value);

    if (step.next !== null) {
    currentStepId = step.next;
    renderStepIndicator();
    renderCurrentStep();
} else if (step.end) {
    completeFlow();
}
});

    // Focus on input
    setTimeout(() => input.focus(), 0);
}

    // Render a multiple choice step
    function renderMultipleChoiceStep(step) {
    let optionsHTML = '';

    step.options.forEach(option => {
    optionsHTML += `<button class="option-button secondary" data-next="${option.next}">${option.text}</button>`;
});

    stepCard.innerHTML = `
                <h3>${step.question}</h3>
                <div class="buttons-container" style="flex-direction: column; align-items: stretch;">
                    ${optionsHTML}
                </div>
            `;

    document.querySelectorAll('.option-button').forEach(button => {
    button.addEventListener('click', () => {
    const next = parseInt(button.dataset.next);
    currentStepId = next;
    renderStepIndicator();
    renderCurrentStep();
});
});
}

    // Initialize the application
init();
