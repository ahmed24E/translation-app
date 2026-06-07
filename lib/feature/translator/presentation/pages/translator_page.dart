import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transelation_p/feature/translator/domain/entities/similar_word_entity.dart';
import 'package:transelation_p/feature/translator/presentation/bloc/translator_bloc.dart';
import 'package:transelation_p/feature/translator/presentation/bloc/translator_event.dart';
import 'package:transelation_p/feature/translator/presentation/bloc/translator_state.dart';
import 'package:transelation_p/feature/translator/presentation/widgets/language_selector_widget.dart';
import 'package:transelation_p/feature/translator/presentation/widgets/source_input_widget.dart';
import 'package:transelation_p/feature/translator/presentation/widgets/translation_result_widget.dart';
import 'package:transelation_p/feature/translator/presentation/widgets/similar_words_widget.dart';

class TranslatorPage extends StatefulWidget {
  const TranslatorPage({super.key});

  @override
  State<TranslatorPage> createState() => _TranslatorPageState();
}

class _TranslatorPageState extends State<TranslatorPage> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FC),
      body: SafeArea(
        child: BlocConsumer<TranslatorBloc, TranslatorState>(
          listener: (context, state) {
            if (state.status == TranslatorStatus.error &&
                state.errorMessage.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: Colors.red.shade400,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'The Linguistic',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1A1A2E),
                                ),
                              ),
                              Text(
                                'Editorial',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1A1A2E),
                                ),
                              ),
                            ],
                          ),
                        ),

                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/history');
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.history_rounded,
                              color: Color(0xFF1A1A2E),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      LanguageSelectorWidget(
                        sourceLang: state.sourceLang,
                        targetLang: state.targetLang,
                        onSourceChanged: (lang) {
                          context.read<TranslatorBloc>().add(
                            ChangeSourceLangEvent(lang),
                          );
                        },
                        onTargetChanged: (lang) {
                          context.read<TranslatorBloc>().add(
                            ChangeTargetLangEvent(lang),
                          );
                        },
                        onSwap: () {
                          context.read<TranslatorBloc>().add(
                            SwapLanguagesEvent(),
                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      SourceInputWidget(
                        controller: _textController,
                        isLoading: state.status == TranslatorStatus.loading,
                        onTranslate: () => _onTranslate(context, state),
                        onClear: () {
                          _textController.clear();
                          context.read<TranslatorBloc>().add(
                            ClearTranslationEvent(),
                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      if (state.status == TranslatorStatus.success &&
                          state.translation != null)
                        TranslationResultWidget(
                          translation: state.translation!,
                        ),

                      if (state.status == TranslatorStatus.success &&
                          state.translation != null)
                        const SizedBox(height: 16),

                      if (state.similarWords.isNotEmpty)
                        SimilarWordsWidget(
                          words: state.similarWords,
                          onWordTap: (word) =>
                              _onSimilarWordTap(context, state, word),
                        ),
                    ]),
                  ),
                ),
              ],
            );
          },
        ),
      ),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: Icons.translate_rounded,
                  label: 'Translate',
                  isActive: true,
                  onTap: () {},
                ),

                _buildNavItem(
                  icon: Icons.history_rounded,
                  label: 'History',
                  isActive: false,
                  onTap: () => Navigator.pushNamed(context, '/history'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTranslate(BuildContext context, TranslatorState state) {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    context.read<TranslatorBloc>().add(
      TranslateEvent(
        sourceText: text,
        sourceLang: state.sourceLang,
        targetLang: state.targetLang,
      ),
    );
  }

  void _onSimilarWordTap(
    BuildContext context,
    TranslatorState state,
    SimilarWordEntity word,
  ) {
    _textController.text = word.sourceWord;
    context.read<TranslatorBloc>().add(
      TranslateEvent(
        sourceText: word.sourceWord,
        sourceLang: state.sourceLang,
        targetLang: state.targetLang,
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF1A1A2E) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isActive ? Colors.white : const Color(0xFF9E9E9E),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : const Color(0xFF9E9E9E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
