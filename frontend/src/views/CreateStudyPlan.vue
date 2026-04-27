<template>
    <main>
        <div id="form-generator">
            <form action="POST" @submit.prevent="MakeStudyPlan()">
                <div>
                    <div>
                        <label for="subject">Fagområde:</label>
                        <input id="subject" v-model="inp.subject" type="text" placeholder="Samfunnskunnskap" required />
                    </div>
                    <div>
                        <label for="level">Nivå:</label>
                        <input id="level" v-model="inp.level" type="text" placeholder="Yrkesfag" required />
                    </div>
                    <div>
                        <label for="topic">Tema:</label>
                        <input id="topic" v-model="inp.topic" type="text" placeholder="Velferdsstaten" required />
                    </div>
                    <div>
                        <label for="exam_date">Dato for prøve / eksamen:</label>
                        <input id="exam_date" v-model="inp.exam_date" type="date" required />
                    </div>
                    <div>
                        <label for="test_type">Tema:</label>
                        <input id="test_type" v-model="inp.test_type" type="text" placeholder="fagsamtale" required />
                    </div>
                    <div>
                        <label for="language">Språk:</label>
                        <input id="language" v-model="inp.language" type="text" placeholder="Norsk" required />
                    </div>
                </div>
                <div><button type="submit"><span>lag study plan</span></button></div>
            </form>
            <br>
            <section v-if="data">
                <div>
                    <li>{{ data.study_plan.subject }}</li>
                    <li>{{ data.study_plan.level }}</li>
                    <li>{{ data.study_plan.topic }}</li>
                    <li>{{ data.study_plan.exam_date }}</li>
                    <li>{{ data.study_plan.test_type }}</li>
                    <li>{{ data.study_plan.generated_date }}</li>
                    <li>{{ data.study_plan.language }}</li>
                </div>
                <br>
                <div>
                    <h2>Flashcards:</h2>
                    <div v-for="(set, key) in data.study_plan.flashcards" :key="key">
                        <h3>Set: {{ key }}</h3>
                        <div v-for="(card, i) in set" :key="i" style=" margin-bottom: 1rem;">
                            <label for="{{ i }}">Spørsmål: {{ i + 1 }}</label>
                            <textarea name="{{ i }}" id="" v-model="card.question"
                                style="width: 100%; resize: vertical">
                            </textarea>
                            <br>
                            <label for="{{ i }}">svar:</label>
                            <textarea name="{{ i }}" id="" v-model="card.answer" style="width: 100%; resize: vertical;"
                                rows="5">do not remove this!
                            </textarea>

                        </div>
                    </div>
                </div>
                <br>
                <div>
                    <h2>Multiple Choice:</h2>
                    <div v-for="(mc, i) in data.study_plan.multiple_choice" :key="i">
                        <label for="{{ i }}">Spørsmål: {{ i }}</label>
                        <textarea name="{{ i }}" id="" v-model="mc.question" style="width: 100%; resize: vertical">
                        do not remove this!
                        </textarea>
                        <p>riktig svar: {{ mc.correct_answer_index + 1 }} </p>
                        <div v-for="(options, x) in mc.options" :key="x">
                            <label for="{{ x + 1 }}">{{ x + 1 }}</label>
                            <textarea name="{{ x + 1 }}" id="" v-model="mc.options[x]"
                                style="width: 100%; resize: vertical">do not remove this!</textarea>

                        </div>

                    </div>
                </div>
                <br>
                <div>
                    <p v-for="(day, i) in data.study_plan.days" :key="i">{{ day.date }}: {{ day.focus }}</p>
                </div>
            </section>
            <!-- <pre>{{ data.study_plan.flashcards }}</pre>
            <pre>{{ data.study_plan.multiple_choice }}</pre> -->
            <button @click.prevent="postStudyPlan()" type="submit">Lag studieplan</button>
        </div>
    </main>
</template>
<script>
import axios from 'axios';
export default {
    data() {
        return {
            data: {
                "study_plan": {
                    "subject": "Naturfag",
                    "level": "Yrkesfag",
                    "topic": "Bølger og akkustikk",
                    "exam_date": "2026-03-28",
                    "test_type": "Skriftlig prøve",
                    "generated_date": "2025-01-10",
                    "language": "Norsk",
                    "flashcards": {
                        "1": [
                            {
                                "question": "Hva er en bølge?",
                                "answer": "En bølge er en forstyrrelse som beveger seg gjennom et medium og overfører energi uten å transportere materie."
                            },
                            {
                                "question": "Hva er forskjellen mellom transversale og longitudinale bølger?",
                                "answer": "Transversale bølger svinger vinkelrett på bevegelsesretningen (f.eks. lysbølger), mens longitudinale bølger svinger parallelt med bevegelsesretningen (f.eks. lydbølger)."
                            },
                            {
                                "question": "Hva er bølgelengde?",
                                "answer": "Bølgelengden er avstanden mellom to påfølgende bølgetopper eller bølgedaler, målt i meter."
                            },
                            {
                                "question": "Hva er frekvens?",
                                "answer": "Frekvens er antall svingninger per sekund, målt i Hertz (Hz)."
                            },
                            {
                                "question": "Hva er amplitude?",
                                "answer": "Amplitude er den maksimale utslaget fra likevektsstillingen, og beskriver bølgens styrke eller intensitet."
                            }
                        ],
                        "2": [
                            {
                                "question": "Hva er lydhastigheten i luft ved romtemperatur?",
                                "answer": "Lydhastigheten i luft ved romtemperatur (20°C) er ca. 343 m/s."
                            },
                            {
                                "question": "Hva er sammenhengen mellom bølgehastighet, frekvens og bølgelengde?",
                                "answer": "Formelen er v = f × λ, der v er bølgehastighet, f er frekvens og λ er bølgelengde."
                            },
                            {
                                "question": "Hva er en lydkilde?",
                                "answer": "En lydkilde er et objekt som vibrerer og setter luftmolekylene i bevegelse, slik at lydbølger oppstår."
                            },
                            {
                                "question": "Hvordan påvirker temperatur lydhastigheten?",
                                "answer": "Lydhastigheten øker når temperaturen øker, fordi luftmolekylene beveger seg raskere ved høyere temperaturer."
                            },
                            {
                                "question": "Hva er resonans?",
                                "answer": "Resonans oppstår når et objekt vibrerer med sin naturlige frekvens og forsterker lyden."
                            }
                        ],
                        "3": [
                            {
                                "question": "Hva er refleksjon av lydbølger?",
                                "answer": "Refleksjon er når lydbølger spretter tilbake fra en overflate, noe som kan skape ekko."
                            },
                            {
                                "question": "Hva er absorpsjon av lyd?",
                                "answer": "Absorpsjon er når lydenergi omdannes til varme når lydbølger treffer et materiale, slik at lyden dempes."
                            },
                            {
                                "question": "Hva er Doppler-effekten?",
                                "answer": "Doppler-effekten er endringen i observert frekvens når lydkilden eller lytteren beveger seg i forhold til hverandre."
                            },
                            {
                                "question": "Hva er desibel (dB)?",
                                "answer": "Desibel er en måleenhet for lydintensitet eller lydstyrke på en logaritmisk skala."
                            },
                            {
                                "question": "Hva er støyforurensning?",
                                "answer": "Støyforurensning er uønsket eller skadelig lyd i miljøet som kan påvirke helse og trivsel negativt."
                            }
                        ]
                    },
                    "multiple_choice": [
                        {
                            "question": "Hvilken type bølge er en lydbølge?",
                            "options": [
                                "Transversal bølge",
                                "Longitudinal bølge",
                                "Elektromagnetisk bølge",
                                "Overflatebølge"
                            ],
                            "correct_answer_index": 1
                        },
                        {
                            "question": "Hva er enheten for frekvens?",
                            "options": [
                                "Meter (m)",
                                "Sekund (s)",
                                "Hertz (Hz)",
                                "Desibel (dB)"
                            ],
                            "correct_answer_index": 2
                        },
                        {
                            "question": "Hva skjer med bølgelengden når frekvensen øker, gitt at hastigheten er konstant?",
                            "options": [
                                "Bølgelengden øker",
                                "Bølgelengden forblir den samme",
                                "Bølgelengden avtar",
                                "Bølgelengden dobles"
                            ],
                            "correct_answer_index": 2
                        },
                        {
                            "question": "Hvor forplanter lyd seg raskest?",
                            "options": [
                                "I vakuum",
                                "I luft",
                                "I vann",
                                "I stål"
                            ],
                            "correct_answer_index": 3
                        },
                        {
                            "question": "Hva kalles det når lydbølger spretter tilbake fra en overflate?",
                            "options": [
                                "Absorpsjon",
                                "Refleksjon",
                                "Refraksjon",
                                "Diffraksjon"
                            ],
                            "correct_answer_index": 1
                        },
                        {
                            "question": "Hvilket fenomen forklarer hvorfor en ambulansesirene lyder høyere når den nærmer seg?",
                            "options": [
                                "Resonans",
                                "Interferens",
                                "Doppler-effekten",
                                "Absorpsjon"
                            ],
                            "correct_answer_index": 2
                        },
                        {
                            "question": "Hva måler amplitude i en lydbølge?",
                            "options": [
                                "Tonehøyden",
                                "Lydstyrken",
                                "Lydhastigheten",
                                "Frekvensen"
                            ],
                            "correct_answer_index": 1
                        },
                        {
                            "question": "Hva er en naturlig frekvens?",
                            "options": [
                                "Frekvensen til alle lydbølger",
                                "Frekvensen lyd har i vakuum",
                                "Frekvensen et objekt foretrekker å vibrere med",
                                "Den høyeste frekvensen mennesker kan høre"
                            ],
                            "correct_answer_index": 2
                        },
                        {
                            "question": "Hvilken påstand om lyd er korrekt?",
                            "options": [
                                "Lyd kan forplante seg i vakuum",
                                "Lyd trenger et medium for å forplante seg",
                                "Lyd er en elektromagnetisk bølge",
                                "Lyd beveger seg alltid med samme hastighet"
                            ],
                            "correct_answer_index": 1
                        },
                        {
                            "question": "Hva kalles det når to bølger møtes og forsterker hverandre?",
                            "options": [
                                "Destruktiv interferens",
                                "Konstruktiv interferens",
                                "Refleksjon",
                                "Absorpsjon"
                            ],
                            "correct_answer_index": 1
                        }
                    ],
                    "days": [
                        {
                            "date": "2025-01-13",
                            "focus": "Introduksjon til bølger",
                            "tasks": {
                                "Task 1": {
                                    "description": "Les om grunnleggende bølgeteori: hva er en bølge, typer bølger (transversale og longitudinale), og bølgenes egenskaper"
                                },
                                "Task 2": {
                                    "description": "Gå gjennom flashcards om grunnleggende bølgebegreper",
                                    "type": "Flashcards",
                                    "set": 1
                                }
                            }
                        },
                        {
                            "date": "2025-01-20",
                            "focus": "Bølgeparametre",
                            "tasks": {
                                "Task 1": {
                                    "description": "Studer bølgelengde, frekvens, amplitude ogperioden. Øv på å identifisere disse i diagrammer"
                                },
                                "Task 2": {
                                    "description": "Repetere grunnleggende begreper",
                                    "type": "Flashcards",
                                    "set": 1
                                }
                            }
                        },
                        {
                            "date": "2025-01-27",
                            "focus": "Bølgeformelen",
                            "tasks": {
                                "Task 1": {
                                    "description": "Lær formelen v = f × λ og løs øvingsoppgaver med beregninger av bølgehastighet, frekvens og bølgelengde"
                                },
                                "Task 2": {
                                    "description": "Test deg selv med multiple choice spørsmål om bølgeparametre"
                                }
                            }
                        },
                        {
                            "date": "2025-02-03",
                            "focus": "Introduksjon til akustikk",
                            "tasks": {
                                "Task 1": {
                                    "description": "Les om lyd som longitudinale bølger, lydkilder og hvordan lyd oppstår"
                                },
                                "Task 2": {
                                    "description": "Studer flashcards om lydegenskaper",
                                    "type": "Flashcards",
                                    "set": 2
                                }
                            }
                        },
                        {
                            "date": "2025-02-10",
                            "focus": "Lydhastighet",
                            "tasks": {
                                "Task 1": {
                                    "description": "Studer lydhastighet i forskjellige medier (luft, vann, faste stoffer) og faktorer som påvirker lydhastigheten"
                                },
                                "Task 2": {
                                    "description": "Løs beregningsoppgaver relatert til lydhastighet og bølgeformelen"
                                }
                            }
                        },
                        {
                            "date": "2025-02-17",
                            "focus": "Resonans og naturlig frekvens",
                            "tasks": {
                                "Task 1": {
                                    "description": "Les om resonans, naturlig frekvens og praktiske eksempler på resonansfenomener"
                                },
                                "Task 2": {
                                    "description": "Repetere akustikkbegreper",
                                    "type": "Flashcards",
                                    "set": 2
                                }
                            }
                        },
                        {
                            "date": "2025-02-24",
                            "focus": "Refleksjon og absorpsjon",
                            "tasks": {
                                "Task 1": {
                                    "description": "Studer refleksjon av lydbølger, ekko, og absorpsjon i forskjellige materialer"
                                },
                                "Task 2": {
                                    "description": "Gå gjennom flashcards om lydrefleksjon og absorpsjon",
                                    "type": "Flashcards",
                                    "set": 3
                                }
                            }
                        },
                        {
                            "date": "2025-03-03",
                            "focus": "Doppler-effekten",
                            "tasks": {
                                "Task 1": {
                                    "description": "Les om Doppler-effekten, hvordan den fungerer og praktiske eksempler fra hverdagen"
                                },
                                "Task 2": {
                                    "description": "Se videoer eller demonstrasjoner av Doppler-effekten og noter viktige observasjoner"
                                }
                            }
                        },
                        {
                            "date": "2025-03-10",
                            "focus": "Lydintensitet og desibel",
                            "tasks": {
                                "Task 1": {
                                    "description": "Studer lydintensitet, desibel-skalaen og hørselsskader forårsaket av høye lydnivåer"
                                },
                                "Task 2": {
                                    "description": "Repetere alle flashcards om akustikk",
                                    "type": "Flashcards",
                                    "set": 3
                                }
                            }
                        },
                        {
                            "date": "2025-03-17",
                            "focus": "Repetisjon og sammenhenger",
                            "tasks": {
                                "Task 1": {
                                    "description": "Gjennomgå alle temaer og lag et sammendrag av viktige formler, begreper og sammenhenger"
                                },
                                "Task 2": {
                                    "description": "Løs alle multiple choice spørsmålene og identifiser svake områder"
                                }
                            }
                        },
                        {
                            "date": "2025-03-24",
                            "focus": "Intensiv repetisjon",
                            "tasks": {
                                "Task 1": {
                                    "description": "Gå gjennom alle flashcards systematisk",
                                    "type": "Flashcards",
                                    "set": 1
                                },
                                "Task 2": {
                                    "description": "Fortsett med alle flashcard-settene",
                                    "type": "Flashcards",
                                    "set": 2
                                }
                            }
                        },
                        {
                            "date": "2025-03-25",
                            "focus": "Fordypning og øving",
                            "tasks": {
                                "Task 1": {
                                    "description": "Repetere avanserte begreper",
                                    "type": "Flashcards",
                                    "set": 3
                                },
                                "Task 2": {
                                    "description": "Løs tidligere eksamensoppgaver eller prøver relatert til bølger og akustikk"
                                }
                            }
                        },
                        {
                            "date": "2025-03-26",
                            "focus": "Praktiske anvendelser",
                            "tasks": {
                                "Task 1": {
                                    "description": "Studer praktiske anvendelser av akustikk i yrkesfag (f.eks. støykontroll, lyddesign, bygningsakustikk)"
                                },
                                "Task 2": {
                                    "description": "Gjennomgå notater og lag en oversikt over de viktigste poengene til eksamen"
                                }
                            }
                        },
                        {
                            "date": "2025-03-27",
                            "focus": "Siste repetisjon",
                            "tasks": {
                                "Task 1": {
                                    "description": "Rask gjennomgang av alle flashcards - fokus på vanskelige begreper",
                                    "type": "Flashcards",
                                    "set": 1
                                },
                                "Task 2": {
                                    "description": "Les gjennom sammendraget ditt, slapp av og sørg for god søvn før eksamen"
                                }
                            }
                        }
                    ]
                }
            },
            inp: {
                subject: '',
                level: '',
                topic: '',
                exam_date: '',
                test_type: '',
                language: ''
            }
        }
    },
    methods: {
        async MakeStudyPlan() {
            const form = new FormData()
            form.append('subject', this.inp.subject)
            form.append('level', this.inp.level)
            form.append('topic', this.inp.topic)
            form.append('exam_date', this.inp.exam_date)
            form.append('test_type', this.inp.test_type)
            form.append('language', this.inp.language)
            try {
                const res = await axios.post('/api/study-plan/generate/', form)
                this.data = res.data
                console.log(this.data)
            }
            catch (error) {
                console.error(error)
            }
        },
        async postStudyPlan(){
            try{
                const res = await axios.post('/api/study-plan/save/', this.data)
                console.log(res.status)
            }catch(error){
                console.error(error)
            }
        }


    }
}
</script>

<style scoped>
main {
    /* grid-column: 1 / -1; */
    padding-top: 5rem;
    width: 100vw;
    box-sizing: border-box;

}

#form-generator {
    max-width: 100vw;
    margin: 0 auto;
    padding: 4rem;
}
</style>